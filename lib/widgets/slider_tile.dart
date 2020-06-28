import 'package:flutter/material.dart';

class SliderTile extends StatelessWidget {

  SliderTile({this.imageAssetPath, this.title, this.description});

  final String imageAssetPath, title, description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imageAssetPath),
            radius: 100.0,
          ),
          SizedBox(height: 17.0),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
              color: Colors.grey.shade700
            ),
          ),
          SizedBox(height: 12.0),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}