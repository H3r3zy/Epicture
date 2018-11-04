import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Created by sahel the 04/11/18 at 11:55

class PostPageState extends State<PostPage> {
  static const galleryPlatform = const MethodChannel("Epicture/Gallery");
  static const cameraPlatform = const MethodChannel("Epicture/Camera");

  _getGallery() async {
    var res;

    /*try {
      res = await galleryPlatform.invokeMethod(method)
    }*/
  }

  @override
  Widget build(BuildContext context) {
    // TODO implement build
    return Container(
      child: Center(
        child: Text("PHOTO")
      )
    );
  }
}

class PostPage extends StatefulWidget {

  PostPage({Key key}) : super(key: key);

  @override
  PostPageState createState() => new PostPageState();
}