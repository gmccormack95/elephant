import 'package:Elephant/model/settings_constants.dart';
import 'package:Elephant/util/app_colors.dart';
import 'package:Elephant/util/settings.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'home.dart';

class IntroductionPage extends StatefulWidget {
  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  List<PageViewModel> listPagesViewModel = [
    PageViewModel(
      titleWidget: Text(
        'Welcome to Elephant!',
        style: TextStyle(
          color: AppColors.grey,
          fontSize: 24.0,
          fontWeight: FontWeight.w300
        ),
      ),
      bodyWidget: Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Text(
          'Please take the tour to guide you through the app...',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 16.0,
            fontWeight: FontWeight.w300
          ),
        ),
      ),
      image: Container(
        padding: const EdgeInsets.only(top: 80),
        child: Image.asset('assets/images/splash_screen.png')
      )
    ),
    PageViewModel(
      titleWidget: Text(
        'Total Habits',
        style: TextStyle(
          color: AppColors.grey,
          fontSize: 24.0,
          fontWeight: FontWeight.w300
        ),
      ),
      bodyWidget: Text(
        'Here you can write the description of the page, to explain someting the total habits etc...',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.grey,
          fontSize: 16.0,
          fontWeight: FontWeight.w300
        ),
      ),
      image: Container(
        padding: const EdgeInsets.only(top: 80),
        child: Image.asset('assets/images/intro_image_1.png')
      )
    ),
    PageViewModel(
      title: "Title of page",
      body: "Page description",
      image: Container(
        width: double.infinity,
        height: 150,
        color: Colors.blue,
        alignment: Alignment.center,
        child: Text(
          'Image',
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: listPagesViewModel,
      globalBackgroundColor: Colors.white,
      onDone: () {
        ElephantSettings.setBolean(SETTINGS_INTRO_SHOWN, true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
      showSkipButton: true,
      skip: const Text("Skip"),
      done: const Text(
        "Done", 
        style: TextStyle(
          fontWeight: FontWeight.w600
        )
      ),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: AppColors.grey,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0)
        )
      )
    );
  }
}