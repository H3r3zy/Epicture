library my_prj.globals;

import "package:shared_preferences/shared_preferences.dart";
import "dart:convert";

String clientId = "b56aec72c75dae4";
String clientSecret = "befb3de6031c0f02f3ea01da53046e814b2f533b";

SharedPreferences prefs;

getPrefs(callback) async {
  prefs = await SharedPreferences.getInstance();
  callback();
}

/// ME
dynamic get me {
  if (prefs == null)
    return null;
  var tmp = prefs.get("me");
  if (tmp == null)
    return null;
  var data = json.decode(tmp);
  data["createdAt"] = DateTime.parse(data["createdAt"]);
  return json.decode(tmp);
}

set me(tmp) {
  if (prefs != null) {
    var encoded = json.encode(tmp, toEncodable: (item) {
      if (item is DateTime) {
        return item.toIso8601String();
      }
      return item;
    });
    prefs.setString("me", encoded);
  }
}

/*
DateTime createdAt;
*/

/// userId
String get userId => prefs?.get("userId");
set userId(String value) => prefs?.setString("userId", value);

/// accessToken
String get accessToken => prefs?.get("accessToken");
set accessToken(String value) => prefs?.setString("accessToken", value);

/// refreshToken
String get refreshToken => prefs?.get("refreshToken");
set refreshToken(String value) => prefs?.setString("refreshToken", value);

/// username
String get username => prefs?.get("username");
set username(String value) => prefs?.setString("username", value);

/// expiresIn
int get expiresIn => prefs?.get("expiresIn");
set expiresIn(int value) => prefs?.setInt("expiresIn", value);

/// createdAt
DateTime get createdAt {
  var tmp = prefs?.get("createdAt");
  return DateTime.parse(tmp);
}
set createdAt(DateTime value) => prefs?.setString("createdAt", value.toIso8601String());