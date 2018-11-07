import 'package:cached_network_image/cached_network_image.dart';
import 'package:epicture_flutter/pages/UserPage.dart';
import 'package:flutter/material.dart';

// Created by sahel the 02/11/18 at 11:14

class Avatar extends StatelessWidget {
  final double size;
  @required final String url;
  @required final String username;

  Avatar({Key key, this.username, this.size = 32.0, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (this.url != "null" && this.url != null) ? GestureDetector(
      child: Container(
          constraints: BoxConstraints(maxHeight: this.size),
          alignment: Alignment.topCenter,
          width: this.size,
          height: this.size,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: (this.url != null) ? DecorationImage(
                  image: CachedNetworkImageProvider(this.url)
              ) : null
          )
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => new UserPage(username: this.username)
        ));
      },
    ) : Container(constraints: BoxConstraints(maxHeight: 10.0),);
  }
}