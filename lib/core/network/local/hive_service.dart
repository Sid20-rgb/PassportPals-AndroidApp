import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../../config/constants/hive_tabel_constant.dart';
import '../../../features/auth/data/model/auth_hive_model.dart';
import '../../../features/home/data/model/home_hive_model.dart';

final hiveServiceProvider = Provider<HiveService>((ref) => HiveService());

class HiveService {
  Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    // Register Adapters
    Hive.registerAdapter(AuthHiveModelAdapter());
    Hive.registerAdapter(HomeHiveModelAdapter());

    await addDummyBlog();
  }

  Future<void> addBlog(HomeHiveModel blog) async {
    var box = await Hive.openBox<HomeHiveModel>(HiveTableConstant.blogBox);
    await box.put(blog.blogId, blog);
  }

  Future<List<HomeHiveModel>> getAllBlogs() async {
    var box = await Hive.openBox<HomeHiveModel>(HiveTableConstant.blogBox);
    var blogs = box.values.toList();
    box.close();
    return blogs;
  }

   // get bookmarked books
  Future<List<HomeHiveModel>> getBookmarkedBlogs() async {
    var box = await Hive.openBox<HomeHiveModel>(HiveTableConstant.blogBox);
    var blogs = box.values.toList();
    box.close();
    return blogs;
  }

  // get user books
  Future<List<HomeHiveModel>> getUserBlogs() async {
    var box = await Hive.openBox<HomeHiveModel>(HiveTableConstant.blogBox);
    var blogs = box.values.toList();
    box.close();
    return blogs;
  }

// ======================== user Queries ========================
  Future<void> addUser(AuthHiveModel user) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.put(user.userId, user);
  }

  Future<List<AuthHiveModel>> getAllUsers() async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    var users = box.values.toList();
    box.close();
    return users;
  }

  //Login
  Future<AuthHiveModel?> login(String username, String password) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    var user = box.values.firstWhere((element) =>
        element.username == username && element.password == password);
    box.close();
    return user;
  }

  // ======================== Delete All Data ========================
  Future<void> deleteAllData() async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.clear();
  }

  // ======================== Close Hive ========================
  Future<void> closeHive() async {
    await Hive.close();
  }

  // ======================== Delete Hive ========================
  Future<void> deleteHive() async {
    var directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
    await Hive.deleteFromDisk();
  }

  Future<void> addDummyBlog() async {
  var box = await Hive.openBox<HomeHiveModel>(HiveTableConstant.blogBox);
  if (box.isEmpty) {
    final blog1 = HomeHiveModel(
      title: '1',
      content: 'test1',
      contentImg: ['test1', 'test2'],
      date: 'test1',
      blogCover: 'test1',
      user: {'test1': 'test1'},
    );

    final blog2 = HomeHiveModel(
      title: '2',
      content: 'test2',
      contentImg: ['test1', 'test2'],
      date: 'test2',
      blogCover: 'test1',
      user: {'test2': 'test2'},
    );

    List<HomeHiveModel> blogs = [blog1, blog2];

    for (var blog in blogs) {
      await addBlog(blog);
    }
  }
}

}
