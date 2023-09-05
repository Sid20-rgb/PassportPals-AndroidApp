import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:all_sensors2/all_sensors2.dart';
import 'package:final_mobile/features/home/domain/entity/home_entity.dart';
import 'package:final_mobile/features/home/presentation/view/uploadblog_view.dart';
import 'package:final_mobile/features/home/presentation/viewmodel/home_view_model.dart';
import 'package:final_mobile/features/profile/presentation/viewmodel/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../../../../config/router/app_route.dart';
import '../../../../core/common/provider/internet_connectivity.dart';
import '../../../../core/common/snackbar/my_snackbar.dart';
import '../../../../core/shared_prefs/user_shared_prefs.dart';
import '../../../profile/presentation/viewmodel/logout_view_model.dart';
import 'individual.dart';

class ImageItem {
  final String blogId;
  final String title;
  final Map<String, dynamic> user;
  final String blogCover;
  // final String userProfileImage;
  final DateTime uploadedDate;

  ImageItem(
    this.blogId,
    this.title,
    this.user,
    this.blogCover,
    // this.userProfileImage,
    this.uploadedDate,
  );
}

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  double _proximityValue = 0;
  final List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  String loggedInUsername = '';
  late Map<String, bool> _favoriteStatus;

  // Add a reference to the HomeViewModel
  late HomeViewModel homeViewModel; // Declare the variable

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(proximityEvents!.listen((ProximityEvent event) {
      setState(() {
        _proximityValue = event.proximity;
        if (_proximityValue < 0.2) {
          UserSharedPrefs.clearSharedPrefs();
          ref.read(logoutViewModelProvider.notifier).logout(context);

          Navigator.pushReplacementNamed(context, AppRoute.loginRoute);
          // ignore: avoid_print
          print('logout');
        }
      });
    }));
    fetchLoggedInUsername();
    // Access the HomeViewModel instance from the homeViewModelProvider
    homeViewModel = ref.read(homeViewModelProvider.notifier);
    _favoriteStatus = {};
    retrieveFavoriteStatusFromSharedPreferences();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeViewModel.getAllBlogs();
      homeViewModel.getBookmarkedBlogs();
      homeViewModel.getUserBlogs();
      ref.watch(profileViewModelProvider.notifier).getAllProfile();
    });
    super.initState();
  }

  Future<void> fetchLoggedInUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (username != null) {
      setState(() {
        loggedInUsername = username;
      });
    }
  }

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    saveFavoriteStatusToSharedPreferences();
    super.dispose();
  }

  void retrieveFavoriteStatusFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<dynamic, dynamic> retrievedFavorites =
        jsonDecode(prefs.getString('favorites') ?? '{}');
    setState(() {
      _favoriteStatus = Map<String, bool>.from(retrievedFavorites);
    });
  }

  void saveFavoriteStatusToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteStatusList = _favoriteStatus.entries
        .map((entry) => '${entry.key}:${entry.value}')
        .toList();
    await prefs.setStringList('favoriteStatus', favoriteStatusList);
  }

  @override
  Widget build(BuildContext context) {
    var blogState = ref.watch(homeViewModelProvider);
    final profileState = ref.watch(profileViewModelProvider);
    List<HomeEntity> homeList = blogState.blogs;
    final List<ImageItem> images = homeList.map((blog) {
      return ImageItem(
        blog.blogId!, // Assuming 'blogId' is not nullable in the HomeEntity class
        blog.title,
        blog.user,
        blog.blogCover,
        // 'https://media.timeout.com/images/105894416/750/422/image.jpg',
        DateTime.parse(blog.date),
      );
    }).toList();
    final internetStatus = ref.watch(connectivityStatusProvider);
    double imageHeight = MediaQuery.of(context).size.width * 203 / 350;
    double fieldSize = imageHeight * 0.4;
    final double screenHeight = MediaQuery.of(context).size.height;

    if (profileState.isLoading || blogState.isLoading) {
      return Scaffold(
        body: Center(
          child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: const AlwaysStoppedAnimation(0.0),
                curve: Curves.linear,
              ),
            ),
            child: const CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: screenHeight * 0.2 - 0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Blogs',
                      style: TextStyle(
                        fontSize: imageHeight * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: homeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final isBookmarked = blogState.blogs[index].isBookmarked;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IndividualView(
                                blog: homeList[index],
                                blogId: homeList[index].blogId!,
                                blogCoverUrl:
                                    '${ApiEndpoints.baseUrl}uploads/${homeList[index].blogCover}',
                                title: homeList[index].title,
                                username: homeList[index].user['username'],
                                uploadedDate: homeList[index].date,
                              ),
                            ),
                          );
                        },
                        onDoubleTap: () {
                          final ImageItem currentImage = images[index];
                          final String blogId = currentImage.blogId;
                          if (isBookmarked == true) {
                            homeViewModel.unbookmarkBlog(blogId);
                            showSnackBar(
                              context: context,
                              message: 'Blog unbookmarked',
                              color: Colors.lightGreen,
                            );
                            homeViewModel.getBookmarkedBlogs();
                          } else {
                            homeViewModel.bookmarkBlog(blogId);
                            showSnackBar(
                              context: context,
                              message: 'Blog bookmarked',
                              color: Colors.green,
                            );
                            homeViewModel.getBookmarkedBlogs();
                          }

                          setState(() {
                            if (_favoriteStatus
                                .containsKey(images[index].title)) {
                              _favoriteStatus.remove(images[index].title);
                            } else {
                              _favoriteStatus[images[index].title] = true;
                            }
                          });
                        },
                        child: Container(
                          height: imageHeight,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5.0,
                                spreadRadius: 2.0,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.6),
                                    BlendMode.dstATop,
                                  ),
                                  child: internetStatus ==
                                          ConnectivityStatus.isConnected
                                      ? Image.network(
                                          '${ApiEndpoints.baseUrl}/uploads/${homeList[index].blogCover}',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        )
                                      : Image.asset(
                                          'assets/images/logo.png',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                ),
                              ),
                              // Positioned(
                              //   top: fieldSize * 0.1,
                              //   left: fieldSize * 0.1,
                              //   child: CircleAvatar(
                              //     radius: fieldSize * 0.18,
                              //     // backgroundImage: NetworkImage(
                              //     //   images[index].userProfileImage,
                              //     // ),
                              //   ),
                              // ),
                              Positioned(
                                top: fieldSize * 0.2,
                                left: fieldSize * 0.2,
                                child: SizedBox(
                                  width: fieldSize * 2,
                                  child: Text(
                                    "@" + images[index].user["username"],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: fieldSize * 0.12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: fieldSize * 0.3,
                                left: fieldSize * 0.1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: fieldSize * 3,
                                      child: Text(
                                        images[index].title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: fieldSize * 0.2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: fieldSize * 0.05),
                                    Text(
                                      DateFormat('dd MMM yyyy')
                                          .format(images[index].uploadedDate),
                                      style: TextStyle(
                                        fontFamily: 'Comfortaa',
                                        color: Colors.white,
                                        fontSize: fieldSize * 0.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Favorite Icon
                              Positioned(
                                top: fieldSize * 0.2,
                                right: fieldSize * 0.1,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  width: fieldSize * 0.2,
                                  height: fieldSize * 0.2,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        blogState.blogs[index].isBookmarked ==
                                                true
                                            ? Colors.yellow
                                            : Colors.transparent,
                                    boxShadow:
                                        blogState.blogs[index].isBookmarked ==
                                                true
                                            ? [
                                                BoxShadow(
                                                  color: Colors.yellow
                                                      .withOpacity(0.5),
                                                  blurRadius: 10.0,
                                                  spreadRadius: 2.0,
                                                ),
                                              ]
                                            : null,
                                  ),
                                  child: Icon(
                                    Icons.favorite,
                                    color:
                                        blogState.blogs[index].isBookmarked ==
                                                true
                                            ? Colors.red
                                            : Colors.grey,
                                    size: fieldSize * 0.20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.8 - 27,
            child: Stack(
              children: [
                Positioned.fill(
                  bottom: screenHeight * 0.6,
                  left: 0,
                  right: 0,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF27272B).withOpacity(0.8),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: screenHeight * 0.04,
                                    backgroundImage: NetworkImage(
                                      '${ApiEndpoints.baseUrl}/uploads/${profileState.profiles[0].image}',
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    loggedInUsername,
                                    style: TextStyle(
                                      fontSize: imageHeight * 0.06,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                              RawMaterialButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BlogUploadScreen(),
                                    ),
                                  );
                                },
                                elevation: 0.0,
                                fillColor: Colors.blueGrey[800],
                                shape: const CircleBorder(),
                                constraints: const BoxConstraints.tightFor(
                                  width: 56.0,
                                  height: 56.0,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: screenHeight * 0.04,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
