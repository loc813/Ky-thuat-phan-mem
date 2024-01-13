// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_app/screens/home_screen.dart';
import 'package:music_app/screens/login_screen.dart';
import 'package:music_app/utils/routes.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import './utils/app_observer.dart';

Future<void> main() async {
  // Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        title: 'Flutter Music',
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        // initialRoute: RouteGenerator.homePage,
        onGenerateInitialRoutes: (String initialRoute) {
          return [
            MaterialPageRoute(builder: (BuildContext context) {
              return StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // print(snapshot.data);
                      return const HomeScreen();
                    } else {
                      return const LoginScreen();
                    }
                  });
            })
          ];
        },
        onGenerateRoute: RouteGenerator.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
