import 'dart:convert';
import 'package:epicture_flutter/globals.dart' as globals;
import 'package:http/http.dart' as http;

class Imgur {
  static const globalEndpoint = "https://api.imgur.com/3/";

  static getHeaders() {
    Map<String, String> header = {};
    if (globals.accessToken != null) {
      header["Authorization"] = "Bearer " + globals.accessToken;
    } else {
      header["Authorization"] = "Client-ID " + globals.clientId;
    }

    return header;
  }

  static getImages({int page = 0, String type = "hot"}) async {
    var uri = globalEndpoint + "gallery/" + type + "/time/" + page.toString() + "?showViral=true&mature=true&album_previews=true";

    var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

    return json.decode(res.body)["data"];
    
  }

  static getAlbumImages(String galleryHash) async {
    var uri = globalEndpoint + "album/$galleryHash/images";

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

    var data = json.decode(res.body)["data"];
    data["createdAt"] = new DateTime.fromMillisecondsSinceEpoch(data["created"] * 1000);
    return data;
  }

  static getImagesOfUser({page = 0, username}) async {
    var uri = globalEndpoint + "account/" + username  + "/submissions/" + page.toString();

    var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

    return json.decode(res.body)["data"];
  }

  static getToken() async {
    var uri = "https://api.imgur.com/oauth2/token";
    var data = {
      "refresh_token": globals.refreshToken,
      "client_id": globals.clientId,
      "client_secret": globals.clientSecret,
      "grant_type": "refresh_token"
    };

    var res = await http.post(Uri.encodeFull(uri), headers: Imgur.getHeaders(), body: data);
    return json.decode(res.body);
  }

  static vote(String galleryHash, String vote) async {
    assert(vote == "up" || vote == "down" || vote == "veto");

    var uri = globalEndpoint + "gallery/" + galleryHash + "/vote/" + vote;

    var res = await http.post(Uri.encodeFull(uri), headers: Imgur.getHeaders());

    return res.statusCode;
  }

  static imageFav(String imageHash) async {
    var uri = globalEndpoint + "image/" + imageHash + "/favorite";

    var res = await http.post(Uri.encodeFull(uri), headers: Imgur.getHeaders());

    return res.statusCode;
  }

  static albumFav(String albumHash) async {
    var uri = globalEndpoint + "album/" + albumHash + "/favorite";

    var res = await http.post(Uri.encodeFull(uri), headers: Imgur.getHeaders());

    return json.decode(res.body)["data"];
  }

  static commentVote(String commentId, String vote) async {
    assert(vote == "up" || vote == "down" || vote == "veto");
    var uri = globalEndpoint + "comment/" + commentId + "/vote/" + vote;

    var res = await http.post(Uri.encodeFull(uri), headers: Imgur.getHeaders());

    return res.statusCode;
  }

  static followTag(String tagName) async {
    var uri = globalEndpoint + "account/me/follow/tag/" + tagName;

    var res = await http.post(Uri.encodeFull(uri), headers: Imgur.getHeaders());

    return res.statusCode;
  }

  static unfollowTag(String tagName) async {
    var uri = globalEndpoint + "account/me/follow/tag/" + tagName;

    var res = await http.delete(Uri.encodeFull(uri), headers: Imgur.getHeaders());

    return res.statusCode;
  }

  static getTag(String tagName) async {
    var uri = globalEndpoint + "gallery/tag_info/" + tagName;

    var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

    return json.decode(res.body)["data"];
  }

  static getFavorites({String username, int page = 0, String sort = "newest"}) async {
    var uri = globalEndpoint + "account/$username/gallery_favorites/$page/$sort";

    var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

    return json.decode(res.body)["data"];
  }

  static sendReply({String imageId, String commentId, String comment}) async {
    var uri = globalEndpoint + "comment/$commentId";
    Map<String, String> data = {
      "image_id": imageId,
      "comment": comment
    };

    var res = await http.post(Uri.encodeFull(uri), headers: Imgur.getHeaders(), body: data);

    return json.decode(res.body)["data"];
  }

  static getComment({String commentId}) async {
    var uri = globalEndpoint + "comment/$commentId";

    var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

    return json.decode(res.body)["data"];
  }

  static delComment({String commentId}) async {
    var uri = globalEndpoint + "comment/$commentId";

    var res = await http.delete(Uri.encodeFull(uri), headers: Imgur.getHeaders());

    return res.statusCode;
  }

  static sendComment({imageId, commentId, comment}) async {
    var uri = globalEndpoint;

    if (commentId != null) {
      uri += "comment/$commentId";
    } else {
      uri += "comment";
    }

    var data = {
      "image_id": imageId,
      "comment": comment
    };

    var res = await http.post(Uri.encodeFull(uri), headers: Imgur.getHeaders(), body: data);
     return json.decode(res.body)["data"];
  }
}