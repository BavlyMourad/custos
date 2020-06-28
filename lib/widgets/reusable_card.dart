import 'package:flutter/material.dart';

// Reusable card to differentiate between each contact in contacts screen
class ReusableCard extends StatelessWidget {
  ReusableCard({@required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: children,
        ),
      ),
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
    );
  }
}
