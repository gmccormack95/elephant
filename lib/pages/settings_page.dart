import 'dart:io';

import 'package:Elephant/util/app_colors.dart';
import 'package:Elephant/widget/settings_item.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final Uri _emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'community@elephantapp.com',
  );

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _getEmail(){
    if(Platform.isAndroid){
      return _emailLaunchUri.toString();
    }else{
      return "mailto:community@elephantapp.com";
    }
  }

  String _getAppStore(){
    if (Platform.isAndroid) {
      return 'market://details?id=com.nicebusiness.elephant';
    } else if (Platform.isIOS) {
      return 'itms-apps://itunes.apple.com/app/id1196992227';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Elephant',
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 24.0,
            fontWeight: FontWeight.w300
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 5.0,
        brightness: Brightness.light,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed:() {
            Navigator.pop(context, false);
          }
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Image.asset(
              'assets/images/settings.png',
              height: 25.0,
              width: 25.0,
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SettingsItem(
              image: Image.asset(
                'assets/images/unlock.png',
                height: 30.0,
                width: 30.0,
              ),
              text: Text(
                'Unlock Full Version',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w200,
                  color: AppColors.grey
                ),
              ),
              onTap: (){
                
              },
              disabled: true,
            ),
            SettingsItem(
              image: Image.asset(
                'assets/images/video.png',
                height: 30.0,
                width: 30.0,
              ),
              text: Text(
                'What\'s Elephant App?',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w200,
                  color: AppColors.grey
                ),
              ),
              onTap: () => _launchURL('https://www.youtube.com/watch?v=ykT7fV5QlyQ'),
            ),
            SettingsItem(
              image: Image.asset(
                'assets/images/contactUs.png',
                height: 30.0,
                width: 30.0,
              ),
              text: Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w200,
                  color: AppColors.grey
                ),
              ),
              onTap: () => _launchURL(_getEmail()),
            ),
            SettingsItem(
              image: Image.asset(
                'assets/images/joinCommunity.png',
                height: 30.0,
                width: 30.0,
              ),
              text: Text(
                'Join Our Community',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w200,
                  color: AppColors.grey
                ),
              ),
            ),
            SettingsItem(
              image: Image.asset(
                'assets/images/RateUs.png',
                height: 30.0,
                width: 30.0,
              ),
              text: Text(
                'Rate This App',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w200,
                  color: AppColors.grey
                ),
              ),
              onTap: () => _launchURL(_getAppStore()),
            ),
            SettingsItem(
              image: Image.asset(
                'assets/images/website.png',
                height: 30.0,
                width: 30.0,
              ),
              text: Text(
                'Visit Our Website',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w200,
                  color: AppColors.grey
                ),
              ),
              onTap: () => _launchURL('http://elephantapp.com/'),
            ),
          ],
        ),
      ),
    );
  }
}