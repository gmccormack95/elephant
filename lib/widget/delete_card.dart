import 'package:flutter/material.dart';

class DeleteCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0, left: 2.0, right: 2.0),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.red,
      ),
      child: Icon(
        Icons.delete,
        color: Colors.white
      ),
    );
  }
}