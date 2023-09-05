import 'package:final_mobile/features/profile/presentation/view/edit_profile.dart';

import '../../features/auth/presentation/view/login.dart';
import '../../features/auth/presentation/view/signup.dart';
import '../../features/comment/presentation/view/comment_view.dart';
import '../../features/dashboard/presentation/view/dashboard.dart';
import '../../features/explorer/presentation/view/explorer.dart';
import '../../features/favorite/presentation/view/favoriteblog.dart';
import '../../features/home/presentation/view/home.dart';
// import '../../features/individual/presentation/view/individual_view.dart';
import '../../features/home/presentation/view/individual.dart';
import '../../features/home/presentation/view/uploadblog_view.dart';
import '../../features/profile/presentation/view/profile.dart';
import '../../features/profile/presentation/view/update_password.dart';
import '../../features/search/presentation/view/search_view.dart';
import '../../features/splash/presentation/view/splash_view.dart';

class AppRoute {
  AppRoute._();
  static const String homeRoute = '/home';
  static const String registerRoute = '/';
  static const String loginRoute = '/login';
  static const String dashRoute = '/dashboard';
  static const String explorerRoute = '/explorer';
  static const String profileRoute = '/profile';
  static const String searchRoute = '/search';
  static const String individualRoute = '/individual';
  static const String uploadRoute = '/upload';
  static const String favoriteRoute = '/favorite';
  static const String commentRoute = '/comment';
  static const String splashRoute = '/splash';
  static const String updatePassword = '/updatePassword';
  static const String editProfile = '/editProfile';
  static const String explorerBlog = '/explorerBlog';

  static getApplicationRoute() {
    return {
      homeRoute: (context) => const Home(),
      registerRoute: (context) => const SignUp(),
      loginRoute: (context) => const LogIn(),
      dashRoute: (context) => const DashboardView(),
      explorerRoute: (context) => const ExplorerView(),
      profileRoute: (context) => const ProfileView(),
      searchRoute: (context) => const SearchView(),
      individualRoute: (context) => const IndividualView(blog: null),
      uploadRoute: (context) => const BlogUploadScreen(),
      favoriteRoute: (context) => const FavoriteView(),
      splashRoute: (context) => const SplashView(),
      commentRoute: (context) => const CommentView(),
      updatePassword: (context) => const UpdatePassword(),
      editProfile: (context) => const EditProfiles(),
    };
  }
}
