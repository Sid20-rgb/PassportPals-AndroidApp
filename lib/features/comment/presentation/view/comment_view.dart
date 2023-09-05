import 'package:final_mobile/core/common/snackbar/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../viewmodel/comment_viewmodel.dart';

class CommentView extends ConsumerStatefulWidget {
  const CommentView({Key? key}) : super(key: key);

  @override
  _CommentViewState createState() => _CommentViewState();
}

class _CommentViewState extends ConsumerState<CommentView> {
  String? blogId;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Function to reload the data when the user triggers a refresh.
  Future<void> _handleRefresh() async {
    // Implement the logic to reload the data here.
    ref.watch(commentViewModelProvider.notifier).getAllComments(blogId!);
  }

  @override
  void didChangeDependencies() {
    blogId = ModalRoute.of(context)!.settings.arguments as String?;
    super.didChangeDependencies();
  }

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final commentState = ref.watch(commentViewModelProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Comment Section',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                    thickness: 1,
                    height: 20,
                  ),
                ],
              ),
            ),
            commentState.comments.isEmpty
                ? const Expanded(
                    child: Text(
                      'No Comments Yet',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: commentState.comments.length,
                      itemBuilder: (BuildContext context, int index) {
                        DateTime createdAt = DateTime.parse(
                            commentState.comments[index].createdAt);
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://img.freepik.com/free-icon/user_318-563642.jpg"),
                          ),
                          title: Text(
                            commentState.comments[index].user.username,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                commentState.comments[index].content,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(createdAt),
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: commentState
                                      .comments[index].isUserLoggedIn ==
                                  true
                              ? IconButton(
                                  onPressed: () {
                                    ref
                                        .watch(
                                            commentViewModelProvider.notifier)
                                        .deleteComment(
                                            commentState.comments[index].id);

                                    showSnackBar(
                                      message: 'Comment Deleted Successfully',
                                      context: context,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        );
                      },
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: commentController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Write a comment',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[900],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.black,
                      onPressed: () {
                        ref
                            .watch(commentViewModelProvider.notifier)
                            .addComment(commentController.text, blogId!);

                        showSnackBar(
                          message: 'Comment Added. Pull Down To Refresh',
                          context: context,
                        );
                        commentController.clear();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
