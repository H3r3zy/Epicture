import 'package:flutter_driver/driver_extension.dart';
import "package:flutter_driver/flutter_driver.dart";
import "package:epicture_flutter/main.dart" as app;
import 'package:test/test.dart';

void main() {
  enableFlutterDriverExtension();
  app.main();

  group("Home Test", () {
    FlutterDriver  driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() {
      if (driver != null)
        driver.close();
    });

    test("wait for image", () async {
      await driver.waitFor(find.text("SHARE"));
    });

    test("tap on image", () async {
      await driver.tap(find.byType("CachedNetworkImage"));

      await driver.waitFor(find.byType("CardAction"));
    });


  });
}