import 'package:epicture_flutter/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:epicture_flutter/globals.dart' as globals;

void main() {
	globals.getPrefs(() {
		runApp(MaterialApp(
			home: new HomePage(),
			theme: new ThemeData(
				accentColor: Colors.white,
				canvasColor: Color.fromRGBO(15, 15, 15, 1.0),
				cardColor: Colors.white,
				unselectedWidgetColor: Colors.white,
				primaryColor: Color.fromRGBO(25, 25, 25, 1.0),
				textTheme: TextTheme(
					body1: TextStyle(color: Colors.white),
					body2: TextStyle(color: Colors.white),
					title: TextStyle(color: Colors.white),
					subtitle: TextStyle(color: Color.fromRGBO(180, 180, 180, 1.0)),
				),
			),
			color: Color.fromRGBO(15, 15, 15, 1.0),
			debugShowCheckedModeBanner: false,
		)
		);
	});
}