import 'package:flutter/material.dart';

class AuthAppBar extends AppBar {
  AuthAppBar(String title)
      : super(
          iconTheme: const IconThemeData(color: Colors.black, size: 20),
          backgroundColor: Colors.white10,
          shadowColor: Colors.white10,
          elevation: 0,
          centerTitle: false,
          title: Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
        );
}
