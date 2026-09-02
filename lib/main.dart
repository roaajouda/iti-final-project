import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/services/hive_service.dart';
import 'package:flutter_application_2/core/theme/app_theme.dart';
import 'package:flutter_application_2/features/auth/provider/auth_user_provider.dart';
import 'package:flutter_application_2/features/category/provider/category_provider.dart';
import 'package:flutter_application_2/features/favourites/provider/favourites_provider.dart';
import 'package:flutter_application_2/features/home/provider/home_provider.dart';
import 'package:flutter_application_2/features/my_lists/provider/my_lists_provider.dart';
import 'package:flutter_application_2/features/profile/provider/profile_provider.dart';
import 'package:flutter_application_2/features/search/provider/search_provider.dart';
import 'package:flutter_application_2/features/splash/view/splash_screen.dart';
import 'package:flutter_application_2/firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final hiveService = HiveService();

  await hiveService.init();

  if (FirebaseAuth.instance.currentUser != null) {
    await hiveService.openUserBoxes();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthUserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavouritesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MyListsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}