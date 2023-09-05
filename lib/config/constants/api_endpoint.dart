class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  // static const String baseUrl = "http://10.0.2.2:3003/";
  static const String baseUrl = "http://192.168.1.66:3003/";

  // ====================== Auth Routes ======================
  static const String login = "users/login";
  static const String register = "users/register";
  static const String getAllBlogs = "blogs/";
  static const String getBookmarkedBlogs = "blogs/bookmarked-blogs";
  static const String getBlogById = "blogs/";
  static const String searchUserBlog = "blogs/searchUser?query=";
  static const String getAllComments = "comments";
  static const String addComment = "comments";
  static const String deleteComment = "comments";
  // static const String getStudentsByBatch = "auth/getStudentsByBatch/";
  // static const String getStudentsByCourse = "auth/getStudentsByCourse/";
  // static const String updateStudent = "auth/updateStudent/";
  // static const String deleteStudent = "auth/deleteStudent/";
  // static const String imageUrl = "http://10.0.2.2:3000/uploads/";
  static const String uploadImage = "users/uploadImage";
  static const String addBlog = "blogs/";
  static const String getAllUsers = "users/users";
  static const String getUser = "users/";
  static const String changePassword = "users/change-password";
  static const String updateProfile = "users/updateProfile";

  static String bookmarkBlog(String blogId) => "blogs/bookmark/$blogId";
  static String unbookmarkBlog(String blogId) => "blogs/bookmark/$blogId";
  static const String searchBlogs = "blogs/search/";
  static const String blogCover = "blogs/uploadBlogCover";

  static const String getUserBlogs = "blogs/uploaded-by-current-user";

  static String updateBlog(String blogId) => "books/$blogId";
  static String deleteBlog(String blogId) => "blogs/$blogId";

  // // ====================== Batch Routes ======================
  // static const String createBatch = "batch/createBatch";
  // static const String getAllBatch = "batch/getAllBatches";

  // // ====================== Course Routes ======================
  // static const String createCourse = "course/createCourse";
  // static const String getAllCourse = "course/getAllCourses";
}
