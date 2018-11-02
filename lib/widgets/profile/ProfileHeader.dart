import 'package:cached_network_image/cached_network_image.dart';
import 'package:epicture_flutter/widgets/Avatar.dart';
import 'package:flutter/material.dart';

// Created by sahel the 02/11/18 at 16:19

class ProfileHeaderState extends State<ProfileHeader> {
  var user;

  ProfileHeaderState(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
          child: Column(
              children: [
                Avatar(url: this.user["avatar"], size: 50.0),
                Text(this.user["url"], style: TextStyle(color: Colors.white, fontSize: 24)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(this.user["reputation_name"] + " ", style: TextStyle(fontSize: 13)),
                      Icon(Icons.brightness_1, size: 4, color: Colors.white),
                      Text(" " + this.user["reputation"].toString() + " Points ", style: TextStyle(fontSize: 13)),
                    ]
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Created " + this.user["createdAt"].month.toString() + "/" + this.user["createdAt"].day.toString() + "/" + this.user["createdAt"].year.toString(), style: TextStyle(fontSize: 13))
                    ]
                )
              ]
          )
      ),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(this.user["cover"])
          )
      ),
    );
  }
}

class ProfileHeader extends StatefulWidget {
  final user;

  ProfileHeader({Key key, this.user}) : super(key: key);

  @override
  ProfileHeaderState createState() => new ProfileHeaderState(this.user);
}