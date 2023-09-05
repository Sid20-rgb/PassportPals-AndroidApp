import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/common/snackbar/my_snackbar.dart';
import '../../domain/entity/home_entity.dart';
import '../viewmodel/home_view_model.dart';

class BlogUploadScreen extends ConsumerStatefulWidget {
  const BlogUploadScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BlogUploadScreen> createState() => _BlogUploadScreenState();
}

class _BlogUploadScreenState extends ConsumerState<BlogUploadScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _contentImgController;
  late TextEditingController _blogCoverController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _contentImgController = TextEditingController();
    _blogCoverController = TextEditingController();
  }

  File? _image;
  List<File>? _contentimg;
  bool _isExpanded = false;

  Future<void> getImage(WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        ref.read(homeViewModelProvider.notifier).uploadBlogCover(_image!);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> getcontentImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickMultiImage();

    setState(() {
      if (pickedImage != null) {
        _contentimg =
            pickedImage.map((pickedImage) => File(pickedImage.path)).toList();
      } else {
        print('No image selected.');
      }
    });
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        getImage(ref);
                      },
                      child: Container(
                        width: double.infinity,
                        height: screenHeight * 0.3,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: _image == null
                            ? const Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 50.0),
                                      Icon(
                                        Icons.add_a_photo,
                                        size: 80,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        'Select the cover image',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Opacity(
                opacity: 0.28,
                child: SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: 'Type title in here',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the title';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Opacity(
                opacity: 0.28,
                child: SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _contentController,
                    textAlignVertical:
                        TextAlignVertical.top, // Align text to the top
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: 'Write your blog here',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: _isExpanded
                            ? 60.0
                            : 140.0, // Increased initial height
                        horizontal: 20.0,
                      ),
                    ),
                    maxLines: null, // Allow the text to wrap to multiple lines
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please write your blog';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await getcontentImage();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff5ab5d1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 90,
                        vertical: 11,
                      ),
                    ),
                    child: const Text(
                      "Add Gallery",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.92,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      final title = _titleController.text;
                      final content = _contentController.text;

                      HomeEntity blog = HomeEntity(
                        title: title,
                        content: content,
                        contentImg: const [],
                        blogCover: 'ok.jpg',
                        date: '',
                        user: const {},
                      );

                      ref.read(homeViewModelProvider.notifier).addBlog(blog);

                      _titleController.clear();
                      _contentController.clear();
                      _contentImgController.clear();
                      _blogCoverController.clear();
                      setState(() {
                        _image = null;
                        // _contentimg = null;

                        Navigator.pop(context);

                        showSnackBar(
                          context: context,
                          message: 'Blog added successfully',
                          color: Colors.green,
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff5ab5d1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 90,
                        vertical: 11,
                      ),
                    ),
                    child: const Text(
                      "Add Blog",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.92,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // CircleAvatar(
                  //   backgroundColor: Colors.white,
                  //   child: IconButton(
                  //     icon: const Icon(Icons.send),
                  //     color: Colors.black,
                  //     onPressed: () {
                  //       // Add send comment functionality here
                  //       final title: _titleController.text;
                  //      final content: _contentController.text;
                  //       // contentImg: _contentImgController.text;
                  //       // blogCover: _blogCoverController.text;

                  //       HomeEntity blog = HomeEntity(
                  //         title: title,
                  //         content: content,
                  //         contentImg: [],
                  //         blogCover: '',
                  //         date: '',
                  //         user: {},

                  //       );

                  //       ref.read(homeViewModelProvider.notifier).addBlog(blog);

                  //       _titleController.clear();
                  //       _contentController.clear();
                  //       _contentImgController.clear();
                  //       _blogCoverController.clear();

                  //       setState(() {
                  //         _image = null;
                  //         // _contentimg = null;

                  //         Navigator.pop(context);

                  //   showSnackBar(
                  //     context: context,
                  //     message: 'Book added successfully',
                  //     color: Colors.green,
                  //   );

                  //       });
                  //     },
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 120.0,
                child: _contentimg == null || _contentimg!.isEmpty
                    ? const SizedBox()
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _contentimg!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.file(
                                _contentimg![index],
                                fit: BoxFit.cover,
                                width: 120.0,
                                height: 120.0,
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 20.0),
              // _contentimg == null
              //     ? const SizedBox()
              //     : ListView.builder(
              //         scrollDirection: Axis.horizontal,
              //         itemCount: _contentimg!.length,
              //         itemBuilder: (BuildContext context, int index) {
              //           return Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: ClipRRect(
              //               borderRadius: BorderRadius.circular(20.0),
              //               child: Image.file(
              //                 _contentimg![index],
              //                 fit: BoxFit.cover,
              //                 width: 120.0,
              //                 height: 120.0,
              //               ),
              //             ),
              //           );
              //         },
              //       ),
            ],
          ),
        ),
      ),
    );
  }
}
