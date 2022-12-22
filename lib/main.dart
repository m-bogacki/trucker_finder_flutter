import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trucker_finder/helpers/theme_helpers.dart';
import 'package:trucker_finder/providers/logged_user_provider.dart';
import 'package:trucker_finder/providers/trucks_provider.dart';
import 'package:trucker_finder/screens/user_management/my_account_screen.dart';
import './providers/users_provider.dart';
import 'package:trucker_finder/screens/auth/password_reset_screen.dart';
import 'package:trucker_finder/screens/trucks/truck_details_screen.dart';
import 'package:trucker_finder/screens/trucks/manage_trucks_screen.dart';
import 'package:trucker_finder/screens/user_management/user_details_screen.dart';
import './screens/auth/welcome_screen.dart';
import './screens/auth/login_screen.dart';
import 'screens/user_management/add_user_screen.dart';
import './screens/home_screen.dart';
import './screens/user_management/manage_users_screen.dart';
import 'providers/auth_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MyApp(),
  );
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
        ChangeNotifierProxyProvider<Auth, LoggedUser>(
          create: (_) => LoggedUser('', '', '', 0),
          update: (context, auth, previousUsers) =>
              auth.loggedUser ??
              LoggedUser(
                  auth.loggedUser?.id ?? '',
                  auth.loggedUser?.firstName ?? '',
                  auth.loggedUser?.lastName ?? '',
                  auth.loggedUser?.profile ?? 0),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Trucker Finder',
          theme: ThemeHelpers.customThemeData(context),
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const Center(
                              child: ThemeHelpers.customSpinner,
                            )
                          : const WelcomeScreen(),
                ),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            AddUserScreen.routeName: (ctx) => AddUserScreen(),
            ManageTrucksScreen.routeName: (ctx) => const ManageTrucksScreen(),
            TruckDetailsScreen.routeName: (ctx) => TruckDetailsScreen(),
            ManageUsersScreen.routeName: (ctx) => ManageUsersScreen(),
            PasswordResetScreen.routeName: (ctx) => PasswordResetScreen(),
            UserDetailsScreen.routeName: (ctx) => UserDetailsScreen(),
            MyAccountScreen.routeName: (ctx) => MyAccountScreen(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
