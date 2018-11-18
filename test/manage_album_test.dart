import 'package:epicture_flutter/pages/ManageAlbum.dart';
import 'package:epicture_flutter/globals.dart' as globals;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

var mock1 = {
	"id": "gDwuEdC",
	"title": "OMG",
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
};

var mock2 = {
	"id": "gDwuEdC",
	"title": "Another album",
	"description": "Petite description",
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
	"in_gallery": true,
	"is_ad": false,
	"include_album_ads": false,
	"deletehash": "6KU1oNvafdM49hL",
	"order": 43
};

void main() {
	group("Manage Albums", () {
		setUpAll(() {
			globals.isTest = true;
		});

		testWidgets("Album not sharing", (WidgetTester tester) async {
			globals.requestMock = mock1;
			await tester.pumpWidget(
				new MaterialApp(
					home: Scaffold(
						body: new ManageAlbumPage("azeaze")
					)
				));

			await tester.pump(Duration(milliseconds: 2000));

			// Check Title
			expect(find.text('Delete this album'), findsOneWidget);
			expect(find.text('Share with the community'), findsOneWidget);

			// Check input title
			expect(find.text('OMG'), findsOneWidget);
		});

		testWidgets("Album sharing", (WidgetTester tester) async {
			globals.requestMock = mock2;
			await tester.pumpWidget(
				new MaterialApp(
					home: Scaffold(
						body: new ManageAlbumPage("azeaze")
					)
				));

			await tester.pump(Duration(milliseconds: 2000));

			// Check Title
			expect(find.text('Delete this album'), findsOneWidget);
			expect(find.text('Remove from the gallery'), findsOneWidget);

			// Check input title
			expect(find.text('Another album'), findsOneWidget);
			expect(find.text('Petite description'), findsOneWidget);
		});
	});
}