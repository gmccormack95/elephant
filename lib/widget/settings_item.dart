import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  SettingsItem({this.image, this.text, this.onTap, this.disabled : false});

  final Image image;
  final Text text;
  final bool disabled;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 30.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: image
            ),
            Opacity(
              opacity: disabled ? 0.2 : 1.0,
              child: text,
            )
          ],
        ),
      ),
    );
  }
}