// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizgame/const/text_styles.dart';

import 'const/colors.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  int seconds = 60;
  

  @override
  Widget build(BuildContext context) {
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
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        CupertinoIcons.return_icon,
                        color: Colors.white,
                        size: 20,
                      )
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      normalText(color: Colors.white, size:18, text: '$seconds'),
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: seconds/60,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    ]
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: lightgrey, width: 2)
                    ),
                    child: TextButton.icon(
                      onPressed: null, 
                      icon: Icon(CupertinoIcons.heart_fill, 
                      color: Colors.white, size: 18), 
                      label: normalText(color: Colors.white, size: 14, text: 'Like'),
                    ),

                  )
                ],
              )
            ]
          ),
        ),
      )
    );
  }
}