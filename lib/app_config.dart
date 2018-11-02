import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class AppConfig extends InheritedWidget {
	AppConfig({
		@required this.appName,
		@required this.clientId,
		@required this.clientSecret,
		@required Widget child,
	}) : super(child: child);

	final String appName;
	final String clientId;
	final String clientSecret;
	String accessToken;
	String refreshToken;
	String username;
	String userId;
	String expiresIn;

	static AppConfig of(BuildContext context) {
		return context.inheritFromWidgetOfExactType(AppConfig);
	}

	@override
	bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
