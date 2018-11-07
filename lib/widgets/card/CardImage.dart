import 'package:cached_network_image/cached_network_image.dart';
import 'package:epicture_flutter/pages/imagepage.dart';
import 'package:flutter/material.dart';

// Created by sahel the 03/11/18 at 21:26

class CardImage extends StatelessWidget {
  @required final String url;
  @required final image;

  CardImage({Key key, this.url, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double ratio = 0.0;

    if (image["is_album"]) {
      ratio = image["images"][0]["width"] / image["images"][0]["height"];
    } else {
      ratio = image["width"] / image["height"];
    }
    return GestureDetector(
          child: Center(
            child: AspectRatio(
                child: CachedNetworkImage(
                    imageUrl: this.url,
                    placeholder: Center(child: CircularProgressIndicator())
                ),
              aspectRatio: ratio,
            )

          ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => new ImagePage(this.image)
          ));
        }
    );
  }
}