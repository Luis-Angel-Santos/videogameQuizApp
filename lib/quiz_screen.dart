// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizgame/const/text_styles.dart';
import 'package:quizgame/service/opentdbApi_service.dart';

import 'const/colors.dart';
import 'const/images.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int seconds = 60;
  Timer? timer;
  var currentQuestionIndex = 0;
  late Future quiz;

  @override
  void initState(){
    super.initState();
    quiz = getQuiz();
    starTimer();
  }

  @override
  void dispose(){
    timer!.cancel();
    super.dispose();
  }

  starTimer(){
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if(seconds > 0){
          seconds--;
        }else{
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

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
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: ,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.hasData){
                  return Column(
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
                            ),
                            SizedBox(height: 20),
                            Image.asset(ideas, width: 200),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: normalText(color: lightgrey, size: 18, text: 'Question ${currentQuestionIndex + 1} of 40'),
                            ),
                            const SizedBox(height: 20),
                            headingText(color: Colors.white, size: 20, text: '10 + 10?'),
                            const SizedBox(height: 20),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: 4,
                              itemBuilder: (BuildContext context, int index){
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  alignment: Alignment.center,
                                  width: size.width - 100,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white, borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: headingText(color: blue, size: 18, text: '20')
                                );
                              }
                            )
                          ]
                        );
                }else{
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      )
    );
  }
}