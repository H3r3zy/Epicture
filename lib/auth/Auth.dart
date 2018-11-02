import 'package:epicture_flutter/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// Created by sahel the 02/11/18 at 19:09

class AuthState extends State<Auth> {
  TextEditingController textEditingController;
  FlutterWebviewPlugin flutterWebviewPlugin;
  static final uri = "https://api.imgur.com/oauth2/authorize";
  static final responseUri = "https://imgur.com/#";
  AppConfig config;

  @override
  Widget build(BuildContext context) {
    this.config = AppConfig.of(context);
    String uri = AuthState.uri + "?client_id=${config.clientId}&response_type=token";
    return WebviewScaffold(
      appBar: AppBar(
        title: Text("Auth")
      ),
      url: uri,
      withZoom: false
    );
  }

  getParams(String url) {
    var response = {};
    var params = url.substring(AuthState.responseUri.length);

    for (var param in params.split("&")) {
      var values = param.split("=");

      response[values[0]] = values[1];
    }
    return response;
  }

  @override
  void initState() {
    super.initState();

    this.flutterWebviewPlugin = new FlutterWebviewPlugin();

    this.flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) async {
      var url = state.url;
      RegExp exp = new RegExp("^$responseUri");
      print(url);

      if (exp.hasMatch(url)) {
        var params = getParams(url);
        print(params);

        config.accessToken = params["access_token"];
        config.refreshToken = params["refresh_token"];
        config.expiresIn = params["expiresIn"];
        config.username = params["account_username"];
        config.userId = params["account_id"];
        await flutterWebviewPlugin.close();
        Navigator.pop(context);
      }
    });
  }
}

class Auth extends StatefulWidget {

  Auth({Key key}) : super(key: key);

  @override
  AuthState createState() => new AuthState();
}