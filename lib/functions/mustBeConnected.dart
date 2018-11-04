import 'package:epicture_flutter/auth/Auth.dart';
import 'package:flutter/material.dart';
import 'package:epicture_flutter/globals.dart' as globals;
import 'package:epicture_flutter/imgur.dart';

refreshToken() async {
  Map<String, dynamic> res = await Imgur.getToken();

  globals.accessToken = res["access_token"] ?? globals.accessToken;
  globals.refreshToken = res["refresh_token"] ?? globals.refreshToken;
  globals.expiresIn = int.parse(res["expires_in"]);
  globals.createdAt = new DateTime.now();
}

isExpired() {
  var now = DateTime.now();
  var expiredms = globals.createdAt.millisecondsSinceEpoch + globals.expiresIn * 1000;
  var expiredAt = DateTime.fromMillisecondsSinceEpoch(expiredms);

  return (now.compareTo(expiredAt) > 0);
}

Future<bool> isConnected() async {
  if (globals.accessToken == null)
    return false;

  if (isExpired()) {
    await refreshToken();
  }
  return true;
}

mustBeConnected(context, callback) async {
  bool connected = await isConnected();
  if (!connected) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Auth();
    }));
    return;
  }
  callback();
}