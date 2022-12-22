import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

abstract class ThemeHelpers {
  static const thirdColor = 0xFFEAEAEA;

  static const accentColor = 0xFFFF8A1C;

  static const primaryColor = 0xFF32373B;

  static final buttonStyle = ButtonStyle(
    fixedSize: MaterialStateProperty.all(Size(300, 45)),
    backgroundColor: MaterialStateProperty.all(
      const Color(primaryColor),
    ),
  );

  static customThemeData(BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: const Color(
        ThemeHelpers.thirdColor,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(
          ThemeHelpers.thirdColor,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(
          ThemeHelpers.thirdColor,
        ),
      ),
      colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: const Color(
              ThemeHelpers.primaryColor,
            ),
            secondary: const Color(
              ThemeHelpers.accentColor,
            ),
          ),
    );
  }

  static const customSpinner = SpinKitFoldingCube(
    color: Color(accentColor),
  );

  static const truckDetailsTextStyle = TextStyle(
    color: Color(primaryColor),
    fontSize: 22,
    fontFamily: 'OpenSans',
  );
}
