import 'package:epicture_flutter/auth/Auth.dart';
import 'package:epicture_flutter/pages/UserPage.dart';
import 'package:flutter/material.dart';
import 'package:epicture_flutter/globals.dart' as globals;

// Created by sahel the 02/11/18 at 19:40

class MeState extends State<Me> {

  @override
  Widget build(BuildContext context) {
    if (globals.username == null)
      return Container(
          child: Center(
              child: FlatButton(
                color: Colors.white,
                child: Text("Auth"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Auth();
                  }));
                },
              )
          )
      );

    return UserPage(username: globals.username, safeArea: false);
  }

  @override
  void initState() {
    super.initState();
  }
}

class Me extends StatefulWidget {

  Me({Key key}) : super(key: key);

  @override
  MeState createState() => new MeState();
}