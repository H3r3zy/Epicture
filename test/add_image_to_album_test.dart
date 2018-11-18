import 'package:epicture_flutter/pages/imageAlbum.dart';
import 'package:epicture_flutter/globals.dart' as globals;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

var mock1 = {
	"id": "O5ganEH",
	"title": "vxnd",
	"description": "Gigi le flotte",
	"datetime": 1542105749,
	"cover": null,
	"cover_width": null,
	"cover_height": null,
	"account_url": "Velo6Raptor",
	"account_id": 96593645,
	"privacy": "public",
	"layout": "blog",
	"views": 343,
	"link": "https://imgur.com/a/O5ganEH",
	"favorite": false,
	"nsfw": null,
	"section": null,
	"images_count": 2,
	"in_gallery": true,
	"is_ad": false,
	"include_album_ads": false,
	"deletehash": "wVNY4SeREoOQZU4",
	"images": [
		{
			"id": "WMLwz0C",
			"title": "igncnc",
			"description": "dvdb",
			"datetime": 1541705723,
			"type": "image/jpeg",
			"animated": false,
			"width": 3024,
			"height": 5376,
			"size": 1416568,
			"views": 645,
			"bandwidth": 913686360,
			"vote": null,
			"favorite": false,
			"nsfw": null,
			"section": null,
			"account_url": null,
			"account_id": null,
			"is_ad": false,
			"in_most_viral": false,
			"has_sound": false,
			"tags": [],
			"ad_type": 0,
			"ad_url": "",
			"in_gallery": false,
			"deletehash": "a5wf1ZzJ3RAYOFd",
			"name": null,
			"link": "https://i.imgur.com/WMLwz0C.jpg"
		},
		{
			"id": "7KjqMQE",
			"title": "olavodv",
			"description": "test",
			"datetime": 1541705655,
			"type": "image/jpeg",
			"animated": false,
			"width": 3024,
			"height": 5376,
			"size": 1416568,
			"views": 473,
			"bandwidth": 670036664,
			"vote": null,
			"favorite": false,
			"nsfw": null,
			"section": null,
			"account_url": null,
			"account_id": null,
			"is_ad": false,
			"in_most_viral": false,
			"has_sound": false,
			"tags": [],
			"ad_type": 0,
			"ad_url": "",
			"in_gallery": false,
			"deletehash": "WyWhNjxQaXw0DJr",
			"name": null,
			"link": "https://i.imgur.com/7KjqMQE.jpg"
		}
	]
};

var mock2 = {
	"id": "O5ganEH",
	"title": "Jailesclé",
	"description": "Ok.",
	"datetime": 1542105749,
	"cover": null,
	"cover_width": null,
	"cover_height": null,
	"account_url": "Velo6Raptor",
	"account_id": 96593645,
	"privacy": "secret",
	"layout": "blog",
	"views": 42,
	"link": "https://imgur.com/a/O5ganEH",
	"favorite": false,
	"nsfw": null,
	"section": null,
	"images_count": 2,
	"in_gallery": true,
	"is_ad": false,
	"include_album_ads": false,
	"deletehash": "wVNY4SeREoOQZU4",
	"images": [
		{
			"id": "WMLwz0C",
			"title": "igncnc",
			"description": "dvdb",
			"datetime": 1541705723,
			"type": "image/jpeg",
			"animated": false,
			"width": 3024,
			"height": 5376,
			"size": 1416568,
			"views": 645,
			"bandwidth": 913686360,
			"vote": null,
			"favorite": false,
			"nsfw": null,
			"section": null,
			"account_url": null,
			"account_id": null,
			"is_ad": false,
			"in_most_viral": false,
			"has_sound": false,
			"tags": [],
			"ad_type": 0,
			"ad_url": "",
			"in_gallery": false,
			"deletehash": "a5wf1ZzJ3RAYOFd",
			"name": null,
			"link": "https://i.imgur.com/WMLwz0C.jpg"
		},
		{
			"id": "7KjqMQE",
			"title": "olavodv",
			"description": "test",
			"datetime": 1541705655,
			"type": "image/jpeg",
			"animated": false,
			"width": 3024,
			"height": 5376,
			"size": 1416568,
			"views": 473,
			"bandwidth": 670036664,
			"vote": null,
			"favorite": false,
			"nsfw": null,
			"section": null,
			"account_url": null,
			"account_id": null,
			"is_ad": false,
			"in_most_viral": false,
			"has_sound": false,
			"tags": [],
			"ad_type": 0,
			"ad_url": "",
			"in_gallery": false,
			"deletehash": "WyWhNjxQaXw0DJr",
			"name": null,
			"link": "https://i.imgur.com/7KjqMQE.jpg"
		}
	]
};

void main() {
	group("Imgages and albums", () {
		setUpAll(() {
			globals.isTest = true;
		});
		testWidgets("add image to an album", (WidgetTester tester) async {
			globals.requestMock = mock1;
			await tester.pumpWidget(
				new MaterialApp(
					home: Scaffold(
						body: new imageAlbum("azezae", "azeaze")
					)
				));

			await tester.pump(Duration(milliseconds: 2000));

			// Check Title
			expect(find.text('vxnd'), findsOneWidget);

			// Check data
			expect(find.text('Images: 2'), findsOneWidget);
			expect(find.text('Views: 343'), findsOneWidget);
			expect(find.text('Privacy: public'), findsOneWidget);

			// Check if album are rendering, the second is showed cannot be tested (need to scroll)
			expect(find.text('Add to this album'), findsOneWidget);
		});

		testWidgets("remove image from an album", (WidgetTester tester) async {
			globals.requestMock = mock2;
			await tester.pumpWidget(
				new MaterialApp(
					home: Scaffold(
						body: new imageAlbum("7KjqMQE", "azeaze")
					)
				));

			await tester.pump(Duration(milliseconds: 1000));

			// Check Title
			expect(find.text('Jailesclé'), findsOneWidget);

			// Check data
			expect(find.text('Images: 2'), findsOneWidget);
			expect(find.text('Views: 42'), findsOneWidget);
			expect(find.text('Privacy: secret'), findsOneWidget);

			// Check if album are rendering, the second is showed cannot be tested (need to scroll)
			expect(find.text('Remove from this album'), findsOneWidget);
		});
	});
}