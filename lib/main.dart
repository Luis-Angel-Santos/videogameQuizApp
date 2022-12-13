// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizgame/const/text_styles.dart';
import 'package:quizgame/quiz_screen.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'const/images.dart';
import 'const/colors.dart';

void main() {
  runApp(const MyApp());
}
  
final Uri _github = Uri.parse('https://github.com/Luis-Angel-Santos/');
final Uri _linkedin = Uri.parse('https://www.linkedin.com/in/dev-web-jr-luisangelsantos/');
    
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    Widget splashScreen = SplashScreenView(
      navigateRoute: const QuizApp(),
      duration: 5000,
      imageSize: 200,
      imageSrc: "assets/balloon.png",
      text: "Videogames Quiz",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: splashScreen,
      theme: ThemeData(
        fontFamily: 'quick',
      ),
      title: 'Home',
    );
  }
}

class QuizApp extends StatelessWidget{
  const QuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    var size = MediaQuery.of(context).size;
    final musicHome = AudioPlayer();
    musicHome.stop();
    musicHome.play(AssetSource('musicHome.mp3'));

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [blue, darkBlue],
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: lightgrey, width: 2)
                    ),
                    child: IconButton(
                      onPressed: (){
                        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                      },
                      icon: const Icon(
                        CupertinoIcons.xmark,
                        color: Colors.white,
                        size: 20,
                      )
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: lightgrey, width: 2)
                    ),
                    child: IconButton(
                      onPressed: (){
                        showInfo(context);
                      },
                      icon: const Icon(
                        CupertinoIcons.info,
                        color: Colors.white,
                        size: 20,
                      )
                    ),
                  ),
                ]
              ),
              Image.asset(balloon2),
              const SizedBox(height: 20),
              normalText(color: lightgrey, size: 18, text: 'Welcome to'),
              headingText(color: Colors.white, size: 32, text: 'Videogames Quiz App'),
              const SizedBox(height: 20),
              normalText(
                color: lightgrey,
                size: 16, 
                text: "Do you feel confident about your knowledge of video games? Try answering these questions"),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: (){
                    musicHome.stop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen()));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    alignment: Alignment.center,
                    width: size.width - 100,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(12),
                    ),
                    child: headingText(color: blue, size: 18, text: 'Start')
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void showInfo(BuildContext context) => showDialog(
  context: context, 
  barrierDismissible: false, 
  builder: (BuildContext context) { 
    return Dialog(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.red, width: 2)
                        ),
                        child: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            CupertinoIcons.xmark,
                            color: Colors.red,
                            size: 20,
                          )
                        ),
                      ),
                    ]
                  ),
                  SizedBox(height: 12),
                  headingText(color: Colors.black, size: 22, text: 'Videogames Quiz App'),
                  SizedBox(height: 12),
                  normalText(color: Color.fromARGB(255, 34, 34, 34), size: 18, text: 'Hi! this is my videogame quiz app, I hope you enjoy it!'),
                  SizedBox(height: 16),
                  normalText(color: Color.fromARGB(255, 34, 34, 34), size: 18, text: 'You can follow me on:'),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        onPressed: () async { await launchUrl(_github); }, 
                        icon: FaIcon(FontAwesomeIcons.github,  
                        color: Colors.black, size: 25), 
                        label: normalText(color: Colors.black, size: 18, text:'GitHub'),
                      ),
                      TextButton.icon(
                        onPressed: () async { await launchUrl(_linkedin); }, 
                        icon: FaIcon(FontAwesomeIcons.linkedin, 
                        color: Colors.blue[800], size: 25), 
                        label: normalText(color: Colors.blue[800], size: 18, text:'LinkedIn'),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          );
  },
);