//client_id = b56aec72c75dae4
import 'dart:convert';

import 'package:http/http.dart' as http;

class Imgur {
  static const clientId = "b56aec72c75dae4";
  static const globalEndpoint = "https://api.imgur.com/3/";

  static getHeaders() {
    var header = {
      "Authorization": "Client-ID " + Imgur.clientId
    };

    return header;
  }

  static getImages({int page = 0, String type = "hot"}) async {
    var uri = globalEndpoint + "gallery/" + type + "/time/" + page.toString() + "?showViral=true&mature=true&album_previews=true";

    var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

    return json.decode(res.body)["data"];
    
  }

  static search({String search = "", int page = 0}) async {
    var uri = globalEndpoint + "gallery/search/time/all/" + page.toString() + "?q=" + search;

    var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

    return json.decode(res.body)["data"];
  }

  static getTags() async {
    var uri = globalEndpoint + "tags";

    var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());
    var ret = json.decode(res.body)["data"]["tags"];

    for (var r in ret) {
      r["background"] = "https://i.imgur.com/" + r["background_hash"] + ".jpg";
    }
    return ret;
  }

  static tagSearch({String tag = "", int page = 0}) async {
    var uri = globalEndpoint + "gallery/t/" + tag + "/time/all/" + page.toString();

    var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

    return json.decode(res.body)["data"];
  }

  static getComments(galleryHash, {sort: "best"}) async {
    var uri = globalEndpoint + "gallery/" + galleryHash + "/comments/" + sort;

    var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

    return json.decode(res.body)["data"];
  }

  static getAvatarAccount(username) async {
    var uri = globalEndpoint + "account/" + username + "/avatar";

    var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());
    if (res.body == "")
      return {"avatar": ""};

    return json.decode(res.body)["data"];
  }

  static getAccount(username) async {
    var uri = globalEndpoint + "account/" + username;

    var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

    return json.decode(res.body)["data"];
  }

  static getImagesOfUser({page = 0, username}) async {
    var uri = globalEndpoint + "account/" + username  + "/submissions/" + page.toString();

    var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

    return json.decode(res.body)["data"];
  }
}