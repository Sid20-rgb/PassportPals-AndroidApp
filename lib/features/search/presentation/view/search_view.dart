import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../../../home/domain/entity/home_entity.dart';
import '../../../home/presentation/view/individual.dart';
import '../viewmodel/search_view_model.dart';

class ImageItem {
  final String title;
  final Map<String, dynamic> user;
  final String blogCover;
  // final String userProfileImage;
  // final DateTime uploadedDate;
  final String uploadedDate;

  ImageItem(
    this.title,
    this.user,
    this.blogCover,
    // this.userProfileImage,
    this.uploadedDate,
  );
}

class SearchView extends ConsumerStatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  String searchText = '';
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<ImageItem> images = [];
  List<HomeEntity> searchedBlogs = [];

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchViewModelProvider);
    searchedBlogs = searchState.searchedBlogs;

    images = searchedBlogs.map((searchedBlogs) {
      return ImageItem(
        searchedBlogs.title,
        searchedBlogs.user,
        searchedBlogs.blogCover,
        // 'https://media.timeout.com/images/105894416/750/422/image.jpg',
        // DateTime.parse(searchedBlogs.date),
        // searchedBlogs.date,
        DateFormat('dd-MM-yyyy').format(DateTime.parse(searchedBlogs.date)),
      );
    }).toList();

    double imageHeight = MediaQuery.of(context).size.width * 203 / 350;
    double fieldSize = imageHeight * 0.4;

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: const Color(0xFF27272B).withOpacity(0.8),
              pinned: true,
              expandedHeight: 80.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
              ),
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('Search Blog'),
              ),
            ),
          ];
        },
        body: Builder(
          builder: (BuildContext context) {
            return Column(
              children: [
                Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.fromLTRB(
                      16.0, 16.0, 16.0, 0.0), // Adjusted padding
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                        ref
                            .watch(searchViewModelProvider.notifier)
                            .getSearchedBlogs(searchText);
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
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
                                print(searchedBlogs[index]);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IndividualView(
                                      blog: searchedBlogs[index],
                                      blogCoverUrl:
                                          '${ApiEndpoints.baseUrl}/uploads/${searchedBlogs[index].blogCover}',
                                      title: searchedBlogs[index].title,
                                      username:
                                          searchedBlogs[index].user['username'],
                                      // uploadedDate: DateFormat('dd MMM yyyy')
                                      //     .format(images[index].uploadedDate),
                                      uploadedDate: searchedBlogs[index].date,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: imageHeight,
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
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
                                    // Positioned(
                                    //   top: fieldSize * 0.1,
                                    //   left: fieldSize * 0.1,
                                    //   child: CircleAvatar(
                                    //     radius: fieldSize * 0.18,
                                    //     backgroundImage: NetworkImage(
                                    //       // images[index].userProfileImage,
                                    //     ),
                                    //   ),
                                    // ),
                                    Positioned(
                                      top: fieldSize * 0.2,
                                      left: fieldSize * 0.1,
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
                                      bottom: 30,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              images[index].title,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: fieldSize * 0.2,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: fieldSize * 0.05),
                                            Text(
                                              images[index].uploadedDate,
                                              style: TextStyle(
                                                fontFamily: 'Comfortaa',
                                                color: Colors.white,
                                                fontSize: fieldSize * 0.1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                                height:
                                    20), // Adjust the height as per your requirement
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
