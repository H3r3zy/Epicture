import 'package:epicture_flutter/imgur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:epicture_flutter/globals.dart' as globals;

// Created by sahel the 02/11/18 at 19:09

class AuthState extends State<Auth> {
  TextEditingController textEditingController;
  FlutterWebviewPlugin flutterWebviewPlugin;
  var _listener;
  static final uri = "https://api.imgur.com/oauth2/authorize";
  static final responseUri = "https://imgur.com/#";

  @override
  Widget build(BuildContext context) {
    String uri = AuthState.uri + "?client_id=${globals.clientId}&response_type=token";
    return WebviewScaffold(
        clearCache: false,
        clearCookies: false,
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

    this._listener = this.flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) async {
      var url = state.url;
      RegExp exp = new RegExp("^$responseUri");

      if (exp.hasMatch(url)) {
        var params = getParams(url);

        setState(() {
          globals.accessToken = params["access_token"];
          globals.refreshToken = params["refresh_token"];
          globals.username = params["account_username"];
          globals.userId = params["account_id"];
          globals.expiresIn = int.parse(params["expires_in"]);
          globals.createdAt = new DateTime.now();
        });

        var tmp = await Imgur.getAccount("me");
        setState(() {
          globals.me = tmp;
        });
        var avatar = Imgur.getAvatarAccount("me");
        setState(() {
          globals.me["avatar"] = avatar;
        });

        await flutterWebviewPlugin.close();
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _listener.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }
}

class Auth extends StatefulWidget {

  Auth({Key key}) : super(key: key);

  @override
  AuthState createState() => new AuthState();
}