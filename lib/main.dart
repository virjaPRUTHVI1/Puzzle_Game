import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: PuzzleGame(),
    ),
  );
}

class PuzzleGame extends StatefulWidget {
  const PuzzleGame({super.key});

  @override
  State<PuzzleGame> createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  int count = 0;
  // List<String> list = ['1', '2', '3', '4', '5', '6', '7', '', '8'];
  List<String> list = ['1', '2', '3', '4', '5', '6', '7', '', '8','9','10','11','12','13','14','15'];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    var height = screensize.height;
    // print(height);
    var width = screensize.width;
    //  print(width);
    var minsize = min(width, height);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assert/images/wooden_jpeg_image.jpeg')),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //backgroundColor: Colors.brown.shade800,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: minsize * (50 / 593),
              child: Center(
                child: RichText(
                    text: TextSpan(
                        text: 'PUZZLE ',
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                          text: 'GAME', style: TextStyle(color: Colors.green))
                    ])),
              ),
            ),
            SizedBox(
              height: minsize * (50 / 593),
              child: Center(
                child: Text(
                  _formatTime(count), //step 1
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 400,
                  width: 400,
                  //height: minsize * (45 / 50),
                  //width: minsize * (45 / 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(minsize * (30 / 593)),
                    border: Border.all(
                        width: screensize.width * (5 / 525),
                        color: Colors.white),
                  ),
                  // padding: EdgeInsets.all( screensize.width*(20/525)),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: 16,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => _move(index), //2step
                      child: DecoratedBox(
                        decoration: list[index].isNotEmpty
                            ? BoxDecoration(
                                image: DecorationImage(
                                    // fit: BoxFit.fill,
                                    image: AssetImage(
                                        "assert/images/pruthvi1.jpg")),
                                borderRadius:
                                    BorderRadius.circular(minsize * (30 / 593)),
                                color: Colors.transparent,
                                border: Border.all(
                                  color: Colors.transparent,
                                  width: minsize * (5 / 525),
                                ))
                            : BoxDecoration(),
                        child: Center(
                            child: Text(
                          list[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        )),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: minsize * (20 / 525),
            ),

            //Padding(padding: EdgeInsets.all(screensize.height * (3 / 593))),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    list.shuffle();

                    ///shuffle is used for changes the index..
                    count = 0; //
                  });
                },
                child: Text(
                  'Reset',
                  style: TextStyle(
                      fontSize: screensize.width * (20 / 525),
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                )) //
          ],
        ),
      ),
    );
  }

  void _startTimer() {
    Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(() {
          count++;
        }); //timer.perodic and only timer both are different
      },
    );
  }

  String _formatTime(int count) {
    int minutes = count ~/ 60;
    int seconds = count % 60;
    String minutesStr = minutes < 10 ? '0$minutes' : '$minutes';
    String secondsStr = seconds < 10 ? '0$seconds' : '$seconds';
    return '$minutesStr:$secondsStr';
  }

  void _move(int index) {
    int emptyIndex = list.indexOf('');
    // print("$emptyIndex");
    if (_canMove(index, emptyIndex)) {
      //3 canmove
      setState(() {
        list[emptyIndex] =
            list[index]; //sweap two value index to empty ...........
        list[index] =
            ''; //index will become empty after becoming empty...........
        if (_isSolved()) {
          //4 step
          _showWinDialog(); //5 step
        }
      });
    }
  }

  bool _canMove(int index, int emptyIndex) {
    if (index == emptyIndex)
      return false; //empty container= ontap not move possible;
    int row = index ~/ 4; //row(tap index)
    int col = index % 4;
    int emptyRow = emptyIndex ~/ 4;
    int emptyCol = emptyIndex % 4;
    return (row == emptyRow && (col - emptyCol).abs() == 1) ||
        (col == emptyCol && (row - emptyRow).abs() == 1);
  }

  bool _isSolved() {
    //4 step
    for (int i = 0; i < list.length - 1; i++) {
      if (list[i] != '${i + 1}') return false;

      ///list[0]!='${0+1}'=1;  list[2]!='${1+1}'=2;
    }
    return true;
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Congratulations!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                list.shuffle();
                count = 0;
              });
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }
}
