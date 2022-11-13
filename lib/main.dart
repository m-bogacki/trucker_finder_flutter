import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/helpers/theme_helpers.dart';
import 'package:trucker_finder/providers/trucks_provider.dart';
import './providers/users_provider.dart';
import 'package:trucker_finder/screens/auth/password_reset_screen.dart';
import 'package:trucker_finder/screens/truck_details_screen.dart';
import 'package:trucker_finder/screens/trucks_screen.dart';
import 'package:trucker_finder/screens/userManagement/user_details_screen.dart';
import './screens/auth/welcome_screen.dart';
import './screens/auth/login_screen.dart';
import './screens/auth/addUser_screen.dart';
import './screens/home_screen.dart';
import './screens/userManagement/accounts_screen.dart';
import 'providers/user_provider.dart';
import 'providers/auth_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Trucks>(
          create: (_) => Trucks(null),
          update: (context, auth, previousTrucksPositions) =>
              Trucks(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, Users>(
          create: (_) => Users(null),
          update: (context, auth, previousUsers) => Users(auth.token),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Trucker Finder',
          theme: ThemeData(
            textTheme: Theme.of(context).textTheme.copyWith(),
            colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: const Color(ThemeColors.PrimaryColor),
                secondary: const Color(ThemeColors.AccentColor)),
          ),
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const WelcomeScreen(),
                ),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            AddUserScreen.routeName: (ctx) => AddUserScreen(),
            TrucksScreen.routeName: (ctx) => TrucksScreen(),
            TruckDetailsScreen.routeName: (ctx) => TruckDetailsScreen(),
            AccountsScreen.routeName: (ctx) => AccountsScreen(),
            PasswordResetScreen.routeName: (ctx) => PasswordResetScreen(),
            UserDetailsScreen.routeName: (ctx) => UserDetailsScreen()
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
