import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const XOGame(),
    );
  }
}

class XOGame extends StatefulWidget {
  const XOGame({super.key});

  @override
  State<XOGame> createState() => _XOGameState();
}

class _XOGameState extends State<XOGame> {
  var board = List<List>.generate(
      3, (i) => List<dynamic>.generate(3, (index) => null, growable: false),
      growable: false);
  var boardShapes = List<List>.generate(
      3, (i) => List<dynamic>.generate(3, (index) => null, growable: false),
      growable: false);
  var turn = -1;
  var count = 0;

  @override
  Widget build(BuildContext context) {
    print(board);
    // print('##################################');
    // board[0][0] = 1; board[0][1] = 0; board[0][2] = 0;
    // board[1][0] = 1; board[1][1] = 0; board[1][2] = 0;
    // board[2][0] = 0; board[2][1] = 0; board[2][2] = 1;
    // print(isWin());
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.greenAccent.shade400,
      appBar: AppBar(
        title: Text(
          'Player: ${(turn==-1)? 'O':'X'}',
          style: TextStyle(
            color: Colors.green.shade900,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.greenAccent.shade400,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: width - 40,
          height: width - 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green.shade900, width: 6),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    boxCell(0, 0),
                    boxCell(0, 1),
                    boxCell(0, 2),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    boxCell(1, 0),
                    boxCell(1, 1),
                    boxCell(1, 2),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    boxCell(2, 0),
                    boxCell(2, 1),
                    boxCell(2, 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isWin() {
    //Check all rows
    for (int i = 0; i < 3; i++) {
      bool isRow = true;
      for (int j = 1; j < 3; j++) {
        if (board[i][j] != board[i][j - 1] || board[i][j] == null) {
          isRow = false;
          break;
        }
      }
      if (isRow) {
        print('Win by Row');
        return true;
      }
    }
    //Check Column
    for (int i = 0; i < 3; i++) {
      bool isColumn = true;
      for (int j = 1; j < 3; j++) {
        if (board[j][i] != board[j - 1][i] || board[j][i] == null) {
          isColumn = false;
          break;
        }
      }
      if (isColumn) {
        print('Win by Column');
        return true;
      }
    }
    //Check Diagonal LTR
    bool isDiagonal = true;
    for (int i = 1; i < 3; i++) {
      if (board[i][i] != board[i - 1][i - 1] || board[i][i] == null) {
        isDiagonal = false;
        break;
      }
    }
    if (isDiagonal) {
      print('Win by Diagonal LTR');
      return true;
    }
    //Check Diagonal RTL
    isDiagonal = true;
    int j = 1;
    for (int i = 1; i >= 0; i--) {
      if (board[i][j] != board[i + 1][j - 1] || board[i][j] == null) {
        isDiagonal = false;
        break;
      }
      j++;
    }
    if (isDiagonal) {
      print('Win by Diagonal RTL');
      return true;
    }
    return false;
  }

  Widget boxCell(int row, int col) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          if (board[row][col] == null) {
            print('$turn on shape');
            boardShapes[row][col] = (turn == -1) ? OShape() : XShape();
            board[row][col] = turn;
            setState(() {});
            count++;
            if (count >= 5 && count < 9) {
              if (isWin()) {
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    print('$turn on winning');
                    return AlertDialog(
                      title: (turn==-1)? Text('O has Won'):Text('X has Won'),
                      actions: [
                        MaterialButton(
                            onPressed: () {
                              resetValues();
                              // Close the dialog
                              Navigator.of(context).pop();
                            },
                            padding: EdgeInsets.zero,
                            child: Text('OK')),
                      ],
                    );
                  },
                );
              }
            } else if (count == 9) {
              if (isWin()) {
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: (turn==-1)? Text('O has Won'):Text('X has Won'),
                      actions: [
                        MaterialButton(
                            onPressed: () {
                              resetValues();
                              // Close the dialog
                              Navigator.of(context).pop();
                            },
                            padding: EdgeInsets.zero,
                            child: Text('OK')),
                      ],
                    );
                  },
                );
              }
              else {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('It\'s a Draw'),
                      actions: [
                        MaterialButton(
                            onPressed: () {
                              resetValues();
                              // Close the dialog
                              Navigator.of(context).pop();
                            },
                            padding: EdgeInsets.zero,
                            child: Text('OK')),
                      ],
                    );
                  },
                );
              }
            }
            turn *= -1;
          }
        },
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green.shade900, width: 4),
          ),
          child: boardShapes[row][col],
        ),
      ),
    );
  }
  void resetValues(){
    board = List<List>.generate(
        3, (i) => List<dynamic>.generate(3, (index) => null, growable: false),
        growable: false);
    boardShapes = List<List>.generate(
        3, (i) => List<dynamic>.generate(3, (index) => null, growable: false),
        growable: false);
    turn = -1;
    count = 0;
    setState(() {});
  }
}

///*****************************************************************************

class XShape extends StatelessWidget {
  const XShape({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CustomPaint(
          painter: XPainter(),
        ),
      ),
    );
  }
}

class XPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.green.shade900
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class OShape extends StatelessWidget {
  const OShape({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CustomPaint(
          painter: OPainter(),
        ),
      ),
    );
  }
}

class OPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.green.shade900
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

