import 'dart:io';

import 'package:final_mobile/config/router/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../../../home/domain/entity/home_entity.dart';
import '../../../home/presentation/view/individual.dart';
import '../../../home/presentation/viewmodel/home_view_model.dart';
import '../../domain/entity/profile_entity.dart';
import '../viewmodel/logout_view_model.dart';
import '../viewmodel/profile_view_model.dart';

class ImageItem {
  final String title;
  final String blogCover;
  // final DateTime uploadedDate;
  final String uploadedDate;
  final String? blogId;

  ImageItem(
    this.title,
    this.blogCover,
    this.uploadedDate,
    this.blogId,
  );
}

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  String loggedInUsername = '';
  String loggedInEmail = '';
  XFile? profileImageFile;

  List<ImageItem> images =
      []; // Declare the images list as a class-level variable

  List<HomeEntity> userBlogs = [];
  List<ProfileEntity> profile = [];

  @override
  void initState() {
    super.initState();
    fetchLoggedInUsername();
    fetchLoggedInEmail();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(profileViewModelProvider.notifier).getAllProfile();
    //   ref.read(homeViewModelProvider.notifier).getAllBlogs();
    // });
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

  Future<void> fetchLoggedInEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    if (email != null) {
      setState(() {
        loggedInEmail = email;
      });
    }
  }

  Future fetchLoggedInProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? profileImagePath = prefs.getString('profile_image');
    if (profileImagePath != null) {
      setState(() {
        profileImageFile = XFile(profileImagePath);
      });
    }
  }

  Future<void> updateProfileImage(XFile pickedImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profile_image', pickedImage.path);

    setState(() {
      profileImageFile = pickedImage;
    });
  }

  File? _img;

  Future pickProfileImage(WidgetRef ref) async {
    try {
      // Show dialog to choose between gallery or camera
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Choose Image Source'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: const Text('Gallery'),
                    onTap: () {
                      Navigator.of(context).pop(ImageSource.gallery);
                    },
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    child: const Text('Camera'),
                    onTap: () {
                      Navigator.of(context).pop(ImageSource.camera);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ).then((value) async {
        if (value == null) {
          // User canceled the selection
          return;
        }

        final image = await ImagePicker().pickImage(source: value);
        if (image != null) {
          setState(() {
            _img = File(image.path);
            ref.read(profileViewModelProvider.notifier).uploadImage(_img!);
          });
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Function to reload the data when the user triggers a refresh.
  Future<void> _handleRefresh() async {
    // Implement the logic to reload the data here.
    ref.watch(profileViewModelProvider.notifier).getAllProfile();
    ref.read(homeViewModelProvider.notifier).getAllBlogs();
  }

  @override
  Widget build(BuildContext context) {
    var userBlogsState = ref.watch(homeViewModelProvider);
    final profileState = ref.watch(profileViewModelProvider);
    profile = profileState.profiles;
    userBlogs = userBlogsState.userBlogs;

    images = userBlogs.map((userBlogs) {
      return ImageItem(
        userBlogs.title,
        userBlogs.blogCover,
        // DateTime.parse(userBlogs.date),
        DateFormat('dd-MM-yyyy').format(DateTime.parse(userBlogs.date)),
        userBlogs.blogId,
      );
    }).toList();

    double imageHeight = MediaQuery.of(context).size.width * 203 / 350;
    double fieldSize = imageHeight * 0.4;
    final double screenHeight = MediaQuery.of(context).size.height;

    if (profileState.isLoading) {
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
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth >= 500 && constraints.maxWidth <= 1500) {
                double buttonSize = constraints.maxHeight * 0.10;
                // Layout for wide screens
                return landscape_for(constraints, fieldSize);
              } else {
                // Layout for narrow screens
                return portrait_for(constraints, imageHeight, fieldSize);
              }
            },
          ),
        ),
      ),
    );
  }

//--------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------

  CircleAvatar buildCircleAvatar(BoxConstraints constraints) {
    if (profileImageFile != null) {
      return CircleAvatar(
        radius: constraints.maxWidth * 0.08,
        backgroundImage: FileImage(File(profileImageFile!.path)),
      );
    } else {
      return CircleAvatar(
        radius: constraints.maxWidth * 0.08,
        backgroundImage: NetworkImage(
          '${ApiEndpoints.baseUrl}/uploads/${profile[0].image}',
        ),
      );
    }
  }

// methods
  Padding portrait_for(
      BoxConstraints constraints, double imageHeight, double fieldSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Part
          Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        pickProfileImage(ref);
                      },
                      child: buildCircleAvatar(constraints),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile[0].username,
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            profile[0].email,
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.03,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AppRoute.updatePassword);
                            },
                            elevation: 0.0,
                            fillColor: Colors.blueGrey[800],
                            shape: const CircleBorder(),
                            constraints: BoxConstraints.tightFor(
                              width: constraints.maxHeight * 0.10,
                              height: constraints.maxHeight * 0.10,
                            ),
                            child: const Icon(
                              Icons.update,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Update Password',
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.025,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0),
                      Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AppRoute.editProfile);
                            },
                            elevation: 0.0,
                            fillColor: Colors.blueGrey[800],
                            shape: const CircleBorder(),
                            constraints: BoxConstraints.tightFor(
                              width: constraints.maxHeight * 0.10,
                              height: constraints.maxHeight * 0.10,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.025,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0),
                      Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              ref
                                  .read(logoutViewModelProvider.notifier)
                                  .logout(context);
                            },
                            elevation: 0.0,
                            fillColor: Colors.blueGrey[800],
                            shape: const CircleBorder(),
                            constraints: BoxConstraints.tightFor(
                              width: constraints.maxHeight * 0.10,
                              height: constraints.maxHeight * 0.10,
                            ),
                            child: const Icon(
                              Icons.exit_to_app,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Exit',
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.025,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0),
                      Column(
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/favorite');
                            },
                            elevation: 0.0,
                            fillColor: Colors.blueGrey[800],
                            shape: const CircleBorder(),
                            constraints: BoxConstraints.tightFor(
                              width: constraints.maxHeight * 0.10,
                              height: constraints.maxHeight * 0.10,
                            ),
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Liked Blogs',
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.025,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30.0),
          const Divider(
            color: Colors.grey,
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Posted Blogs',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          // Posted Blogs Part
          const SizedBox(height: 16.0),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: ListView.builder(
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IndividualView(
                                blog: userBlogs[index],
                                blogCoverUrl:
                                    '${ApiEndpoints.baseUrl}/uploads/${userBlogs[index].blogCover}',
                                title: userBlogs[index].title,
                                username: userBlogs[index].user['username'],
                                // uploadedDate: DateFormat('dd MMM yyyy')
                                //     .format(images[index].uploadedDate),
                                uploadedDate: userBlogs[index].date,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: imageHeight,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 1, vertical: 0),
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
                                  child: Image.network(
                                    '${ApiEndpoints.baseUrl}/uploads/${images[index].blogCover}',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          SizedBox(height: fieldSize * 0.10),
                                          Text(
                                            // DateFormat('dd MMM yyyy').format(
                                            //     images[index].uploadedDate),
                                            images[index].uploadedDate,
                                            style: TextStyle(
                                              fontFamily: 'Comfortaa',
                                              color: Colors.white,
                                              fontSize: fieldSize * 0.10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: IconButton(
                                    onPressed: () {
                                      ref
                                          .watch(homeViewModelProvider.notifier)
                                          .deleteBlog(images[index].blogId!);
                                    },
                                    icon: const Icon(Icons.delete_forever),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row landscape_for(BoxConstraints constraints, double fieldSize) {
    return Row(
      children: [
        // Profile Part
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: constraints.maxWidth * 0.3, // Adjust the width as needed
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            pickProfileImage(ref);
                          },
                          child: buildCircleAvatar(constraints),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile[0].username,
                                style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.03,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                profile[0].email,
                                style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.02,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            RawMaterialButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, AppRoute.updatePassword);
                              },
                              elevation: 0.0,
                              fillColor: Colors.blueGrey[800],
                              shape: const CircleBorder(),
                              constraints: BoxConstraints.tightFor(
                                width: constraints.maxHeight * 0.10,
                                height: constraints.maxHeight * 0.10,
                              ),
                              child: const Icon(
                                Icons.update,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Update Password',
                              style: TextStyle(
                                fontSize: constraints.maxWidth * 0.025,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16.0),
                        Column(
                          children: [
                            RawMaterialButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, AppRoute.editProfile);
                              },
                              elevation: 0.0,
                              fillColor: Colors.blueGrey[800],
                              shape: const CircleBorder(),
                              constraints: BoxConstraints.tightFor(
                                width: constraints.maxHeight * 0.10,
                                height: constraints.maxHeight * 0.10,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: constraints.maxWidth * 0.025,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16.0),
                      ],
                    ),
                    SizedBox(height: constraints.maxHeight * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            RawMaterialButton(
                              onPressed: () {
                                ref
                                    .read(logoutViewModelProvider.notifier)
                                    .logout(context);
                              },
                              elevation: 0.0,
                              fillColor: Colors.blueGrey[800],
                              shape: const CircleBorder(),
                              constraints: BoxConstraints.tightFor(
                                width: constraints.maxHeight * 0.10,
                                height: constraints.maxHeight * 0.10,
                              ),
                              child: const Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              'Exit',
                              style: TextStyle(
                                fontSize: constraints.maxWidth * 0.025,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 30.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              RawMaterialButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/favorite');
                                },
                                elevation: 0.0,
                                fillColor: Colors.blueGrey[800],
                                shape: const CircleBorder(),
                                constraints: BoxConstraints.tightFor(
                                  width: constraints.maxHeight * 0.10,
                                  height: constraints.maxHeight * 0.10,
                                ),
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Liked Blogs',
                                style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.025,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        // Posted Blogs Part
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: ListView.builder(
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IndividualView(
                            blog: userBlogs[index],
                            blogCoverUrl:
                                '${ApiEndpoints.baseUrl}/uploads/${userBlogs[index].blogCover}',
                            title: userBlogs[index].title,
                            username: userBlogs[index].user['username'],
                            // uploadedDate: DateFormat('dd MMM yyyy')
                            //     .format(images[index].uploadedDate),
                            uploadedDate: userBlogs[index].date,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      // height: imageHeight,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 9),
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(10),
                      //   boxShadow: const [
                      //     BoxShadow(
                      //       color: Colors.black26,
                      //       blurRadius: 5.0,
                      //       spreadRadius: 2.0,
                      //     ),
                      //   ],
                      // ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.6),
                                BlendMode.dstATop,
                              ),
                              child: Image.network(
                                '${ApiEndpoints.baseUrl}/uploads/${images[index].blogCover}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: fieldSize * 0.9 - 140,
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
                                      fontSize: fieldSize * 0.1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: fieldSize * 0.10),
                                Text(
                                  // DateFormat('dd MMM yyyy')
                                  //     .format(images[index].uploadedDate),
                                  images[index].uploadedDate,
                                  style: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    color: Colors.white,
                                    fontSize: fieldSize * 0.06,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: IconButton(
                                onPressed: () {
                                  ref
                                      .watch(homeViewModelProvider.notifier)
                                      .deleteBlog(images[index].blogId!);
                                },
                                icon: const Icon(Icons.delete_forever),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
