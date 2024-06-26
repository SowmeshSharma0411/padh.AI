import 'package:dotslash/auth/firebase_auth_methods.dart';
import 'package:dotslash/auth/login_screen.dart';
import 'package:dotslash/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'MyEduApp',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: LoginView(),
    // );
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        // Other providers if any
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ReadMore',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData && snapshot.data != null) {
              return HomeView(); // If user is logged in, show home screen
            } else {
              return LoginScreen(); // If user is not logged in, show login screen
            }
          },
        ),
      ),
    );
  }
}
