import 'package:epicture_flutter/widgets/AlbumsList.dart' as album;
import 'package:epicture_flutter/globals.dart' as globals;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

var mock1 = {
	"data": [
		{
			"id": "gDwuEdC",
			"title": "OMG2",
			"description": null,
			"datetime": 1541648583,
			"cover": null,
			"cover_width": null,
			"cover_height": null,
			"account_url": "Velo6Raptor",
			"account_id": 96593645,
			"privacy": "public",
			"layout": "blog",
			"views": 0,
			"link": "https://imgur.com/a/gDwuEdC",
			"favorite": false,
			"nsfw": null,
			"section": null,
			"images_count": 0,
			"in_gallery": false,
			"is_ad": false,
			"include_album_ads": false,
			"deletehash": "6KU1oNvafdM49hL",
			"order": 43
		},
		{
			"id": "NYNs53h",
			"title": "OLALALA",
			"description": null,
			"datetime": 1541616304,
			"cover": "0JkcrAT",
			"cover_width": 3840,
			"cover_height": 1738,
			"account_url": "Velo6Raptor",
			"account_id": 96593645,
			"privacy": "public",
			"layout": "blog",
			"views": 1,
			"link": "https://imgur.com/a/NYNs53h",
			"favorite": false,
			"nsfw": null,
			"section": null,
			"images_count": 2,
			"in_gallery": false,
			"is_ad": false,
			"include_album_ads": false,
			"deletehash": "bJEu8MvMLocArHN",
			"order": 44
		},
	],
	"success": true,
	"status": 200
};

var image = {
	"id": "q7s876B",
	"title": "olalala",
	"description": null,
	"datetime": 1542498583,
	"cover": null,
	"cover_width": null,
	"cover_height": null,
	"account_url": "Velo6Raptor",
	"account_id": 96593645,
	"privacy": "secret",
	"layout": "blog",
	"views": 0,
	"link": "https://imgur.com/a/q7s876B",
	"favorite": false,
	"nsfw": null,
	"section": null,
	"images_count": 1,
	"in_gallery": false,
	"is_ad": false,
	"include_album_ads": false,
	"deletehash": "fYceXi3nfSo1Hid",
	"order": 0
};

void main() {
	group("Albums", () {
		setUpAll(() {
			globals.isTest = true;
			globals.requestMock = mock1;
		});
		testWidgets("Album list", (WidgetTester tester) async {
			await tester.pumpWidget(
				new MaterialApp(
					home: Scaffold(
						body: new album.albumPage(null)
					)
				));

			await tester.pump(Duration(milliseconds: 2000));

			// Check Title and Icon
			expect(find.text('Add a new Album'), findsOneWidget);
			expect(find.byIcon(Icons.settings), findsOneWidget);

			// Check if album are rendering, the second is showed cannot be tested (need to scroll)
			expect(find.text('OMG2'), findsOneWidget);
			expect(find.text('public - 0 images - 0 views'), findsOneWidget);
		});

		testWidgets("Album list --> Manage Image", (WidgetTester tester) async {
			await tester.pumpWidget(
				new MaterialApp(
					home: Scaffold(
						body: new album.albumPage(image["id"])
					)
				));

			await tester.pump(Duration(milliseconds: 1000));

			// Check Title and Icon
			expect(find.text('Manage album'), findsOneWidget);
			expect(find.byIcon(Icons.remove_red_eye), findsOneWidget);

			// Check if album are rendering, the second is showed cannot be tested (need to scroll)
			expect(find.text('OMG2'), findsOneWidget);
			expect(find.text('public - 0 images - 0 views'), findsOneWidget);
		});
	});
}