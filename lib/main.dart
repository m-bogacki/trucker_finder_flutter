import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/helpers/theme_helpers.dart';
import 'package:trucker_finder/providers/trucks.dart';
import 'package:trucker_finder/screens/trucks_map_screen.dart';
import './screens/auth/welcome_screen.dart';
import './screens/auth/login_screen.dart';
import './screens/auth/register_screen.dart';
import 'screens/home_screen.dart';

import 'providers/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Trucks>(
          create: (_) => Trucks(null),
          update: (context, auth, previousTrucksPositions) =>
              Trucks(auth.token),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Trucker Finder',
          theme: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: ThemeColors.PrimaryColor,
                ),
          ),
          home: auth.isAuth ? HomeScreen() : WelcomeScreen(),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            RegisterScreen.routeName: (ctx) => RegisterScreen(),
            TrucksMapScreen.routeName: (ctx) => TrucksMapScreen(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
