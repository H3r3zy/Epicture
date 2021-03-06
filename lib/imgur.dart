import 'dart:convert';
import 'package:epicture_flutter/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:io';

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
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "gallery/" + type + "/time/" + page.toString() + "?showViral=true&mature=true&album_previews=true";

		var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

		return json.decode(res.body)["data"];
	}

	static getAlbumImages(String galleryHash) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "album/$galleryHash/images";

		var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

		return json.decode(res.body)["data"];
	}

	static search({String search = "", int page = 0}) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "gallery/search/time/all/" + page.toString() + "?q=" + search;

		var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

		return json.decode(res.body)["data"];
	}

	static getTags() async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "tags";

		var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());
		var ret = json.decode(res.body)["data"]["tags"];

		for (var r in ret) {
			r["background"] = "https://i.imgur.com/" + r["background_hash"] + ".jpg";
		}
		return ret;
	}

	static tagSearch({String tag = "", int page = 0}) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "gallery/t/" + tag + "/time/all/" + page.toString();

		var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

		return json.decode(res.body)["data"];
	}

	static getComments(galleryHash, {sort: "best"}) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "gallery/" + galleryHash + "/comments/" + sort;

		var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

		return json.decode(res.body)["data"];
	}

	static getAvatarAccount(username) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "account/" + username + "/avatar";

		var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());
		if (res.body == "")
			return {"avatar": ""};

		return json.decode(res.body)["data"];
	}

	static getAccount(username) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "account/" + username;

		var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

		var data = json.decode(res.body)["data"];
		data["createdAt"] = new DateTime.fromMillisecondsSinceEpoch(data["created"] * 1000);
		return data;
	}

	static getImagesOfUser({page = 0, username}) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "account/" + username + "/submissions/" + page.toString();

		var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

		return json.decode(res.body)["data"];
	}

	static destroyImageOfUser(username, id) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "/image/$id";

		var res = await http.delete(Uri.encodeFull(uri), headers: Imgur.getHeaders());

		return json.decode(res.body)["data"];
	}

	static shareImageWithTheCommunity(id, title, topic, tags) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "/gallery/image/$id";

		var res = await http.post(Uri.encodeFull(uri), headers: Imgur.getHeaders(),
			body: {
				"title": title,
				"topic": topic,
				"terms": "1",
				"mature": "0",
				"tags": tags,
			}
		);
		return json.decode(res.body)["data"];
	}

	static shareAlbumWithTheCommunity(id, title, topic, tags) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "/gallery/album/$id";

		var res = await http.post(Uri.encodeFull(uri), headers: Imgur.getHeaders(),
			body: {
				"title": title,
				"topic": topic,
				"terms": "1",
				"mature": "0",
				"tags": tags,
			}
		);
		return json.decode(res.body)["data"];
	}

	static removeFromTheGallery(id) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "/gallery/$id";

		var res = await http.delete(Uri.encodeFull(uri), headers: Imgur.getHeaders());
		return json.decode(res.body)["data"];
	}

	static getToken() async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

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
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		assert(vote == "up" || vote == "down" || vote == "veto");

		var uri = globalEndpoint + "gallery/" + galleryHash + "/vote/" + vote;

		var res = await http.post(Uri.encodeFull(uri), headers: Imgur.getHeaders());

		return res.statusCode;
	}

	static imageFav(String imageHash) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "image/" + imageHash + "/favorite";

		var res = await http.post(Uri.encodeFull(uri), headers: Imgur.getHeaders());

		return res.statusCode;
	}

	static albumFav(String albumHash) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "album/" + albumHash + "/favorite";

		var res = await http.post(Uri.encodeFull(uri), headers: Imgur.getHeaders());

		return json.decode(res.body)["data"];
	}

	static commentVote(String commentId, String vote) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		assert(vote == "up" || vote == "down" || vote == "veto");
		var uri = globalEndpoint + "comment/" + commentId + "/vote/" + vote;

		var res = await http.post(Uri.encodeFull(uri), headers: Imgur.getHeaders());

		return res.statusCode;
	}

	static followTag(String tagName) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "account/me/follow/tag/" + tagName;

		var res = await http.post(Uri.encodeFull(uri), headers: Imgur.getHeaders());

		return res.statusCode;
	}

	static unfollowTag(String tagName) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "account/me/follow/tag/" + tagName;

		var res = await http.delete(Uri.encodeFull(uri), headers: Imgur.getHeaders());

		return res.statusCode;
	}

	static getTag(String tagName) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "gallery/tag_info/" + tagName;

		var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

		return json.decode(res.body)["data"];
	}

	static getFavorites({String username, int page = 0, String sort = "newest"}) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "account/$username/gallery_favorites/$page/$sort";

		var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

		return json.decode(res.body)["data"];
	}

	static sendReply({String imageId, String commentId, String comment}) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "comment/$commentId";
		Map<String, String> data = {
			"image_id": imageId,
			"comment": comment
		};

		var res = await http.post(Uri.encodeFull(uri), headers: Imgur.getHeaders(), body: data);

		return json.decode(res.body)["data"];
	}

	static getComment({String commentId}) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "comment/$commentId";

		var res = await http.get(Uri.encodeFull(uri), headers: Imgur.getHeaders());

		return json.decode(res.body)["data"];
	}

	static delComment({String commentId}) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "comment/$commentId";

		var res = await http.delete(Uri.encodeFull(uri), headers: Imgur.getHeaders());

		return res.statusCode;
	}

	static sendComment({imageId, commentId, comment}) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

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

	static getAccountImage() async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var uri = globalEndpoint + "account/me/images";

		var res = await http.get(
			uri,
			headers: Imgur.getHeaders()
		);
		var data = json.decode(res.body)["data"];

		for (var d in data) {
			if (d["ups"] == null)
				d["ups"] = 0;
			if (d["downs"] == null)
				d["downs"] = 0;
			if (d["favorite_count"] == null)
				d["favorite_count"] = 0;
			if (d["score"] == null)
				d["score"] = 0;
		}
		return data;
	}

	static getAlbumListFromUser(username) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var url = globalEndpoint + "account/$username/albums/";
		var response = await http.get(url,
			headers: Imgur.getHeaders()
		);
		return await json.decode(response.body);
	}

	static getAlbumListFromUserByPage(page, username) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var url = globalEndpoint + "account/$username/albums/$page";
		var response = await http.get(url,
			headers: Imgur.getHeaders()
		);
		return await json.decode(response.body);
	}

	static getAlbumData(id, username) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var url = globalEndpoint + "account/$username/album/$id";
		var response = await http.get(url,
			headers: Imgur.getHeaders()
		);
		return await json.decode(response.body)["data"];
	}

	static addImageToAnAlbum(id, image) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var url = globalEndpoint + "/album/$id/add";
		var response = await http.post(url,
			headers: Imgur.getHeaders(),
			body: {
				"ids[]": image
			}
		);
		return await json.decode(response.body)["data"];
	}

	static removeImageToAnAlbum(id, image) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var url = globalEndpoint + "/album/$id/remove_images";
		var response = await http.post(url,
			headers: Imgur.getHeaders(),
			body: {
				"ids[]": image
			}
		);
		return await json.decode(response.body)["data"];
	}

	static createAlbum(title, description, privacy) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var url = globalEndpoint + "album";

		var response = await http.post(url,
			headers: Imgur.getHeaders(),
			body: {
				"title": title,
				"description": description,
				"privacy": privacy
			});
		return await json.decode(response.body);
	}

	static deleteAlbum(id) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var url = globalEndpoint + "/album/$id";
		var response = await http.delete(url,
			headers: Imgur.getHeaders()
		);
		return await json.decode(response.body);
	}

	static updateAlbumParams(id, title, description, privacy) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var url = globalEndpoint + "album/$id";

		var response = await http.post(url,
			headers: Imgur.getHeaders(),
			body: {
				"title": title,
				"description": description,
				"privacy": privacy
			});
		return await json.decode(response.body);
	}

	static updateImageParams(id, title, description) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var url = globalEndpoint + "image/$id";

		var response = await http.post(url,
			headers: Imgur.getHeaders(),
			body: {
				"title": title,
				"description": description,
			});
		return await json.decode(response.body);
	}

	static getAlbumImage(id) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var url = globalEndpoint + "/album/$id/images";
		var response = await http.get(url,
			headers: Imgur.getHeaders()
		);
		return await json.decode(response.body)["data"];
	}

	static uploadImage(title, description, File image, privacy) async {
		// flutter_test
		if (globals.isTest == true)
			return globals.requestMock;

		var url = globalEndpoint + "image";

		List<int> imageBytes = image.readAsBytesSync();
		String base64Image = base64Encode(imageBytes);

		var response = await http.post(url,
			headers: Imgur.getHeaders(),
			body: {
				"title": title,
				"description": description,
				"image": base64Image,
				"privacy": privacy
			});
		return await json.decode(response.body);
	}
}