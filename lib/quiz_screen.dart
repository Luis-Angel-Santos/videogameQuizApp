// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizgame/const/text_styles.dart';
import 'package:quizgame/main.dart';
import 'package:quizgame/service/opentdbApi_service.dart';
import 'const/colors.dart';
import 'const/images.dart';


class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final musicBack = AudioPlayer();
  final music = AudioPlayer();
  int seconds = 30;
  Timer? timer;
  var currentQuestionIndex = 0;
  late Future quiz;
  var isLoaded = false;
  var optionsList = [];
  var points = 0;
  var optionsColor = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];

  @override
  void initState(){
    super.initState();
    quiz = getQuiz();
    startTimer();
    musicBack.play(AssetSource('quiz.mp3'));
  }

  @override
  void dispose(){
    timer!.cancel();
    super.dispose();
    musicBack.stop();
  }

  startTimer(){
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          timer!.cancel();
          gotoNextQuestion();
        }
      });
    });
  }

  gotoNextQuestion() {
    isLoaded = false;
    currentQuestionIndex++;
    resetColors();
    timer!.cancel();
    seconds = 30;
    startTimer();
  }

  resetColors(){
    optionsColor = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
    ];
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
              future: quiz,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.hasData){
                  var data = snapshot.data['results'];
                  if(isLoaded == false){
                    optionsList = data[currentQuestionIndex]['incorrect_answers'];
                    optionsList.add(data[currentQuestionIndex]['correct_answer']);
                    optionsList.shuffle();
                    isLoaded = true;
                  }
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
                                      musicBack.stop()
                                        .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => QuizApp())));  
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
                                        value: seconds/30,
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
                                    onPressed: (){ showInfo(context); }, 
                                    icon: Icon(CupertinoIcons.question, 
                                    color: Colors.white, size: 18), 
                                    label: normalText(color: Colors.white, size: 14, text:'Help'),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            Image.asset(ideas, width: 200),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: normalText(color: lightgrey, size: 18, text: 'Question ${currentQuestionIndex + 1} of ${data.length}'),
                            ),
                            const SizedBox(height: 20),
                            headingText(color: Colors.white, size: 20, text: data[currentQuestionIndex]['question']),
                            const SizedBox(height: 20),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: optionsList.length,
                              itemBuilder: (BuildContext context, int index){
                                var answer = data[currentQuestionIndex]['correct_answer'];
                                return GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      if(answer == optionsList[index].toString()){
                                        music.play(AssetSource('correcta.mp3'));
                                        optionsColor[index] = Colors.green;
                                        points = points + 1;
                                      }else{
                                        music.play(AssetSource('error.mp3'));
                                        optionsColor[index] = Colors.red;
                                      }
                                      if(currentQuestionIndex < data.length - 1){
                                        Future.delayed(Duration(seconds: 1), () {
                                          gotoNextQuestion();
                                      });
                                      }else{
                                        music.play(AssetSource('fin.mp3'));
                                        timer!.cancel();
                                        showDialog(
                                          context: context, 
                                          barrierDismissible: false, 
                                          builder: (BuildContext context) { 
                                            return Dialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          SizedBox(height: 12),
                                                          headingText(color: Colors.black, size: 20, text: 'Game Over!'),
                                                          SizedBox(height: 12),
                                                          normalText(color: Colors.black, size: 18, text: 'Finished game. Your score is $points'),
                                                          SizedBox(height: 20),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              TextButton(
                                                            child: Text('Play Again'),
                                                            onPressed: () => {
                                                              musicBack.stop()
                                                                .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen()))),
                                                            }
                                                          ),
                                                            TextButton(
                                                              child: Text('Home'),
                                                              onPressed: () => {
                                                               musicBack.stop()
                                                                .then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => QuizApp()))),
                                                              }
                                                            )
                                                            ],
                                                          ),
                                                          SizedBox(height: 12),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                          },
                                        );
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    alignment: Alignment.center,
                                    width: size.width - 100,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: optionsColor[index], 
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: headingText(color: blue, size: 18, text: optionsList[index].toString()) 
                                  ),
                                );
                              }
                            )
                          ]
                        );
                }else{
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    ]            
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
                  SizedBox(height: 12),
                  headingText(color: Colors.black, size: 20, text: 'How play?'),
                  SizedBox(height: 12),
                  normalText(color: Color.fromARGB(255, 34, 34, 34), size: 18, text: 'You have 30 seconds to answer each question and at the end of the game your score will appear.'),
                  SizedBox(height: 12),
                  normalText(color: Color.fromARGB(255, 34, 34, 34), size: 18, text: 'Good luck!!'),
                  SizedBox(height: 12),
                  TextButton(
                    child: Text('Back to game'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          );
  },
);