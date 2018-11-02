import 'package:epicture_flutter/app_config.dart';
import 'package:epicture_flutter/auth/Auth.dart';
import 'package:flutter/material.dart';

// Created by sahel the 02/11/18 at 19:40

class MeState extends State<Me> {

  @override
  Widget build(BuildContext context) {
    var config = AppConfig.of(context);

    if (config.username == null)
      return Container(child: Center(child: Text("Connectez vous")));

    return Container(
      child: Center(
        child: Text(config.username),
      )
    );
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