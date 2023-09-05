import 'package:final_mobile/features/profile/domain/entity/profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../viewmodel/explorer_view_model.dart';

class ImageItem {
  final String imageUrl;
  final String user;
  final String email;

  ImageItem(this.imageUrl, this.user, this.email);
}

class ExplorerView extends ConsumerStatefulWidget {
  const ExplorerView({Key? key}) : super(key: key);

  @override
  ConsumerState<ExplorerView> createState() => _ExplorerViewState();
}

class _ExplorerViewState extends ConsumerState<ExplorerView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String searchText = '';

  List<ImageItem> imageItems = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(explorerViewModelProvider.notifier).getAllUsers();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userState = ref.watch(explorerViewModelProvider);
    List<ProfileEntity> explorerList = userState.users;
    final List<ImageItem> images = explorerList.map((user) {
      return ImageItem(
        user.image == null
            ? 'https://wallpapers.com/images/featured/miles-morales-bhbtlxz0ovcy8z8c.jpg'
            : '${ApiEndpoints.baseUrl}/uploads/${user.image}',
        user.username,
        user.email,
      );
    }).toList();

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
                title: Text('Explorer'),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.fromLTRB(
                16.0,
                16.0,
                16.0,
                0.0,
              ), // Adjusted padding
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                    ref
                        .watch(explorerViewModelProvider.notifier)
                        .searchAllUsers(searchText);
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
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: searchText == ''
                    ? userState.users.length
                    : userState.search.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      _showImageDialog(
                        context,
                        images[index].imageUrl,
                        images[index].user,
                        images[index].email,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.45),
                                  BlendMode.srcOver,
                                ),
                                child: userState.users[index].image == null
                                    ? Image.network(
                                        'https://wallpapers.com/images/featured/miles-morales-bhbtlxz0ovcy8z8c.jpg',
                                        fit: BoxFit.cover,
                                      )
                                    : searchText == ''
                                        ? Image.network(
                                            '${ApiEndpoints.baseUrl}/uploads/${userState.users[index].image}',
                                            fit: BoxFit.cover,
                                          )
                                        : userState.search[index].image == null
                                            ? Image.network(
                                                'https://wallpapers.com/images/featured/miles-morales-bhbtlxz0ovcy8z8c.jpg',
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                '${ApiEndpoints.baseUrl}/uploads/${userState.search[index].image}',
                                                fit: BoxFit.cover,
                                              ),
                              ),
                            ),
                            Positioned(
                              bottom: 8.0,
                              left: 8.0,
                              right: 8.0,
                              child: ListTile(
                                title: Text(
                                  searchText == ''
                                      ? userState.users[index].username
                                          .toUpperCase()
                                      : userState.search[index].username
                                          .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  searchText == ''
                                      ? userState.users[index].email
                                      : userState.search[index].email,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  void _showImageDialog(
      BuildContext context, String imageUrl, String user, String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                width: 200.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16.0),
              Text(
                'User: $user',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text('Email: $email'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
