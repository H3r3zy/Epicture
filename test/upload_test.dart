import 'package:epicture_flutter/pages/PostPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

var userData = {
	"accesstoken": "8a8d6aa650750cddeb27b036438da14a23c0ad09",
};

void main() {
	group("Upload empty", () {
		testWidgets("Base", (WidgetTester tester) async {
			await tester.pumpWidget(new MaterialApp(
				home: Scaffold(
					body: new PostPage()
				)
			));

			await tester.pump(Duration(milliseconds: 1000));

			// Check default value
			expect(find.text('Enter your image\'s title'), findsOneWidget);
			expect(find.text('Enter your image\'s descriptions'), findsOneWidget);
		});

		testWidgets("cache", (WidgetTester tester) async {
			await tester.pumpWidget(new MaterialApp(
				home: Scaffold(
					body: new PostPage()
				)
			));

			await tester.pump(Duration(milliseconds: 1000));

			// Verify no cache image uploaded
			expect(find.text('No image uploaded'), findsOneWidget);
		});
	});
}