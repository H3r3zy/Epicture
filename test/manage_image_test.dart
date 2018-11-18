import 'package:epicture_flutter/pages/ImageSettings.dart';
import 'package:epicture_flutter/globals.dart' as globals;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

var mock1 = {
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
};

void main() {
	group("Manage Image", () {
		setUpAll(() {
			globals.isTest = true;
			globals.requestMock = mock1;
		});

		testWidgets("Image not sharing", (WidgetTester tester) async {
			await tester.pumpWidget(
				new MaterialApp(
					home: Scaffold(
						body: new ImageSettings(mock1)
					)
				));

			await tester.pump(Duration(milliseconds: 2000));

			// Check button
			expect(find.text('Delete this image'), findsOneWidget);
			expect(find.text('Share with the community'), findsOneWidget);

			// Check input
			expect(find.text('igncnc'), findsOneWidget);
			expect(find.text('dvdb'), findsOneWidget);
		});

		testWidgets("Image sharing", (WidgetTester tester) async {
			mock1["in_gallery"] = true;
			await tester.pumpWidget(
				new MaterialApp(
					home: Scaffold(
						body: new ImageSettings(mock1)
					)
				));

			await tester.pump(Duration(milliseconds: 2000));

			// Check button
			expect(find.text('Delete this image'), findsOneWidget);
			expect(find.text('Remove from the gallery'), findsOneWidget);

			// Check input
			expect(find.text('igncnc'), findsOneWidget);
			expect(find.text('dvdb'), findsOneWidget);
		});
	});
}