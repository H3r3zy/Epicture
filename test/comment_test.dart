import 'package:epicture_flutter/widgets/comment.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

var comment1 = {
  "id": "1518590309",
  "image_id": "aNLuGNS",
  "comment": "Awesome costume!",
  "author": "yournotdealingwiththeaveragesaiyanwarrior",
  "author_id": "45352847",
  "on_album": true,
  "album_cover": "xAhkF5h",
  "ups": 11,
  "downs": 0,
  "points": 11,
  "datetime": 1541090872,
  "parent_id": "0",
  "deleted": false,
  "vote": null,
  "platform": "iphone",
  "children": [
    {
      "id": 1518629277,
      "image_id": "aNLuGNS",
      "comment": "Thanks so much!",
      "author": "ravenhornleather",
      "author_id": "81168429",
      "on_album": true,
      "album_cover": "xAhkF5h",
      "ups": 2,
      "downs": 0,
      "points": 2,
      "datetime": 1541095410,
      "parent_id": "1518590309",
      "deleted": false,
      "vote": null,
      "platform": "iphone",
      "children": [

      ]
    }
  ]
};

var comment2 = {
  "id": "1518590309",
  "image_id": "aNLuGNS",
  "comment": "Awesome costume!",
  "author": "yournotdealingwiththeaveragesaiyanwarrior",
  "author_id": "45352847",
  "on_album": true,
  "album_cover": "xAhkF5h",
  "ups": 11,
  "downs": 0,
  "points": 11,
  "datetime": 1541090872,
  "parent_id": "0",
  "deleted": false,
  "vote": null,
  "platform": "iphone",
  "children": [
  ]
};

var comment3 = {
  "id": "1518590309",
  "image_id": "aNLuGNS",
  "comment": "Awesome costume!",
  "author": "yournotdealingwiththeaveragesaiyanwarrior",
  "author_id": "45352847",
  "on_album": true,
  "album_cover": "xAhkF5h",
  "ups": 11,
  "downs": 0,
  "points": 11,
  "datetime": 1541090872,
  "parent_id": "0",
  "deleted": false,
  "vote": null,
  "platform": "iphone",
  "children": [
    {
      "id": 1518629277,
      "image_id": "aNLuGNS",
      "comment": "Thanks so much!",
      "author": "ravenhornleather",
      "author_id": "81168429",
      "on_album": true,
      "album_cover": "xAhkF5h",
      "ups": 2,
      "downs": 0,
      "points": 2,
      "datetime": 1541095410,
      "parent_id": "1518590309",
      "deleted": false,
      "vote": null,
      "platform": "iphone",
      "children": [

      ]
    },
    {
      "comment": "Test with 2 child",
      "author": "H3r3zy",
      "ups": 2,
      "downs": 0,
      "children": [

      ]
    }
  ]
};

void main() {
  group("Comment", () {
    testWidgets("with reply", (WidgetTester tester) async {

      await tester.pumpWidget(new MaterialApp(
          home: Scaffold(
              body: new Comment(comment: comment1)
          )
      ));

      await tester.pump(Duration(milliseconds: 1000));

      // Verify the number of reply
      expect(find.text('1 reply'), findsOneWidget);
      await tester.tap(find.text("Awesome costume!"));
      await tester.pump(Duration(milliseconds: 1000));

      // Verify the "1 reply" is now "x"
      expect(find.text('x'), findsOneWidget);
      expect(find.text('1 reply'), findsNothing);

      // Verify if the child comment is seen
      expect(find.text("Thanks so much!"), findsOneWidget);

      // Verify the username is visible
      expect(find.text("ravenhornleather"), findsOneWidget);
      expect(find.text("yournotdealingwiththeaveragesaiyanwarrior"), findsOneWidget);
    });

    testWidgets("without reply", (WidgetTester tester) async {

      await tester.pumpWidget(new MaterialApp(
          home: Scaffold(
              body: new Comment(comment: comment2)
          )
      ));

      await tester.pump(Duration(milliseconds: 1000));

      // Verify the number of reply (so Nothing expected)
      expect(find.text('1 reply'), findsNothing);
      await tester.tap(find.text("Awesome costume!"));
      await tester.pump(Duration(milliseconds: 1000));

      // Verify "1 reply" and "x" are not here
      expect(find.text('x'), findsNothing);
      expect(find.text('1 reply'), findsNothing);

      // Verify the username is visible
      expect(find.text("ravenhornleather"), findsNothing);
      expect(find.text("yournotdealingwiththeaveragesaiyanwarrior"), findsOneWidget);
    });
  });

  testWidgets("with replies", (WidgetTester tester) async {

    await tester.pumpWidget(new MaterialApp(
        home: Scaffold(
            body: new Comment(comment: comment3)
        )
    ));

    await tester.pump(Duration(milliseconds: 1000));

    // Verify the number of reply
    expect(find.text('2 replies'), findsOneWidget);
    expect(find.text('1 reply'), findsNothing);
    await tester.tap(find.text("Awesome costume!"));
    await tester.pump(Duration(milliseconds: 1000));

    // Verify the "2 replies" is now "x"
    expect(find.text('x'), findsOneWidget);
    expect(find.text('2 replies'), findsNothing);
    expect(find.text('1 reply'), findsNothing);

    // Verify if the child comment is seen
    expect(find.text("Thanks so much!"), findsOneWidget);
    expect(find.text("Test with 2 child"), findsOneWidget);

    // Verify the username is visible
    expect(find.text("ravenhornleather"), findsOneWidget);
    expect(find.text("yournotdealingwiththeaveragesaiyanwarrior"), findsOneWidget);
    expect(find.text("H3r3zy"), findsOneWidget);
  });
}