import 'dart:convert';

import 'package:final_mobile/config/router/app_route.dart';
import 'package:final_mobile/features/comment/presentation/viewmodel/comment_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../../domain/entity/home_entity.dart';

class IndividualView extends ConsumerStatefulWidget {
  final HomeEntity? blog;
  final String? blogId;
  final String? blogCoverUrl;
  final String? title;
  final String? username;
  final String? uploadedDate;

  const IndividualView({
    Key? key,
    required this.blog,
    this.blogCoverUrl,
    this.blogId,
    this.title,
    this.username,
    this.uploadedDate,
  }) : super(key: key);

  @override
  ConsumerState<IndividualView> createState() => _IndividualViewState();
}

class _IndividualViewState extends ConsumerState<IndividualView> {
  String? content;
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopButton = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBlogContent();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Check if the user has scrolled down enough to show the button
    final showButton = _scrollController.offset > 200;
    if (showButton != _showScrollToTopButton) {
      setState(() {
        _showScrollToTopButton = showButton;
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Future<void> fetchBlogContent() async {
    try {
      final blogId = widget.blog?.blogId;
      final url = Uri.parse(
          '${ApiEndpoints.baseUrl}${ApiEndpoints.getBlogById}/$blogId');
      final response = await http.get(
        url,
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY0Yjc3YzIyNjM0M2U2NTdlMTBmNDU5OSIsInVzZXJuYW1lIjoiYWZ0ZXJ1cyIsImVtYWlsIjoiYWZ0ZXJ1c0BnbWFpbC5jb20iLCJpYXQiOjE2ODk3NDY0NzQsImV4cCI6MTY5MjMzODQ3NH0.qY0Yrlsj9fVqYsSs65W3sChDuH34R-9Y1bs2-mVFipU',
        },
      );

      print('API URL: $url');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final blogContent = json['content'] as String;

        print('Response Body: ${response.body}');

        setState(() {
          content = blogContent;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // void _showNotificationDialog(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Notification'),
  //         content: Text(message),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showNotificationSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.red, // Replace with your desired color
      ),
    );
  }

  void scrollToTipsSection() {
    if (content != null && content!.contains("TIPS and RECOMMENDATIONS")) {
      _scrollController.animateTo(
        content!.indexOf("TIPS and RECOMMENDATIONS").toDouble(),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showNotificationSnackBar(
          "No TIPS and RECOMMENDATIONS section found in the content.");
    }
  }

  void scrollToLinkSection() {
    if (content != null && content!.contains("LINKS and RESOURCES")) {
      _scrollController.animateTo(
        content!.indexOf("LINKS and RESOURCES").toDouble(),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showNotificationSnackBar(
          "No LINKS and RESOURCES section found in the content.");
    }
  }

  void scrollToReviewSection() {
    if (content != null && content!.contains("DESTINATION REVIEWS")) {
      _scrollController.animateTo(
        content!.indexOf("DESTINATION REVIEWS").toDouble(),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showNotificationSnackBar(
          "No DESTINATION REVIEWS section found in the content.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final blog = widget.blog;
    final blogCoverUrl = widget.blogCoverUrl;
    final title = widget.title;
    final username = widget.username;
    final uploadedDate = widget.uploadedDate;

    double imageHeight = MediaQuery.of(context).size.width * 203 / 350;
    double fieldSize = imageHeight * 0.4;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                expandedHeight: constraints.maxHeight * 0.4,
                pinned: true,
                backgroundColor: Colors.black,
                shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100.0),
                    bottomRight: Radius.circular(100.0),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Opacity(
                    opacity: 0.5,
                    child: Image.network(
                      blogCoverUrl ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          DateFormat('dd MMM yyyy')
                              .format(DateTime.parse(uploadedDate ?? '')),
                          style: TextStyle(
                            fontSize: fieldSize * 0.10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          title ?? '',
                          style: TextStyle(
                            fontSize: fieldSize * 0.15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          children: <Widget>[
                            // CircleAvatar(
                            //   backgroundImage: const NetworkImage(
                            //     'https://media.timeout.com/images/105894416/750/422/image.jpg',
                            //   ),
                            //   radius: constraints.maxWidth * 0.025,
                            // ),
                            const SizedBox(width: 8.0),
                            Text(
                              username ?? '',
                              style: TextStyle(
                                fontSize: fieldSize * 0.10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.comment, color: Colors.white),
                    onPressed: () {
                      ref
                          .watch(commentViewModelProvider.notifier)
                          .getAllComments(widget.blogId!);
                      Navigator.pushNamed(context, AppRoute.commentRoute,
                          arguments: widget.blogId);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.map, color: Colors.white),
                    onPressed: () {
                      _showLocationOnMap(context);
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Buttons to navigate to TIPS and RECOMMENDATIONS sections
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: scrollToTipsSection,
                          style: ElevatedButton.styleFrom(
                            elevation: 50,
                          ),
                          child: const Text('TIPS and RECOMMENDATIONS'),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ElevatedButton(
                                  onPressed: scrollToLinkSection,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 50,
                                  ),
                                  child: const Text('LINKS and RESOURCES')),
                              const SizedBox(width: 8.0),
                              ElevatedButton(
                                onPressed: scrollToReviewSection,
                                style: ElevatedButton.styleFrom(
                                  elevation: 50,
                                ),
                                child: const Text('DESTINATION REVIEWS'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(constraints.maxWidth * 0.04),
                      child: content != null
                          ? Text(
                              content!,
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.justify,
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _showScrollToTopButton
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              child: const Icon(Icons.arrow_upward),
            )
          : null,
    );
  }

  void _showLocationOnMap(BuildContext context) async {
    final locationName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Location'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Enter location name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, _searchController.text);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );

    if (locationName != null) {
      try {
        final locations = await locationFromAddress(locationName);
        if (locations.isNotEmpty) {
          final location = locations.first;

          final marker = Marker(
            markerId: const MarkerId('locationMarker'),
            position: LatLng(location.latitude, location.longitude),
            infoWindow: InfoWindow(title: locationName),
          );

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors
                    .transparent, // Set the background color to transparent
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: GoogleMap(
                    markers: {marker},
                    initialCameraPosition: CameraPosition(
                      target: LatLng(location.latitude, location.longitude),
                      zoom: 14,
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          _showNotificationSnackBar('Location not found');
        }
      } catch (e) {
        _showNotificationSnackBar('Error: $e');
      }
    }
  }
}
