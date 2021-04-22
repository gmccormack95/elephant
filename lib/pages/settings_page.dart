import 'dart:io';

import 'package:Elephant/util/app_colors.dart';
import 'package:Elephant/util/mailchimp_manager.dart';
import 'package:Elephant/widget/settings_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController subscribeTextFieldController = TextEditingController();

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

  Future<void> _showSubscribe(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter email to subscribe'),
          content: TextField(
            controller: subscribeTextFieldController,
            decoration: InputDecoration(hintText: "Email"),
          ),
          actions: <Widget>[
            FlatButton(
              textColor: AppColors.grey,
              child: Text('CANCEL'),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
            FlatButton(
              textColor: AppColors.grey,
              child: Text('OK'),
              onPressed: () async {
                Response response = await MailchimpManager.subscribeEmail(subscribeTextFieldController.text);
                String body = response.body;
                Navigator.pop(context);
                subscribeTextFieldController.text = "";
              },
            ),
          ],
        );
      });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Elephant App',
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 24.0,
            fontWeight: FontWeight.bold
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
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 60.0
            ),
            SettingsItem(
              image: Image.asset(
                'assets/images/unlock.png',
                height: 30.0,
                width: 30.0,
              ),
              text: Text(
                'Get Ad-Free Version',
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
                'assets/images/Referal.png',
                height: 30.0,
                width: 30.0,
              ),
              text: Text(
                'Refer a friend',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w200,
                  color: AppColors.grey
                ),
              ),
              onTap: () => Share.share('I found this free habit-reminder app called Elephant, and I think you’ll love it! ' + (Platform.isIOS ? 'https://apps.apple.com/us/app/elephant-never-forget-build/id1196992227?ls=1' : 'https://play.google.com/store/apps/details?id=com.nicebusiness.elephant')),
            ),
            SettingsItem(
              image: Image.asset(
                'assets/images/faq.png',
                height: 30.0,
                width: 30.0,
              ),
              text: Text(
                'FAQs',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w200,
                  color: AppColors.grey
                ),
              ),
              onTap: () => _launchURL('http://elephantapp.com/faq/apps-not-sending-reminders-can-i'),
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
              onTap: () => _showSubscribe(context),
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