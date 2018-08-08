import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(new MyApp());

class RotationYTransition extends AnimatedWidget {
  const RotationYTransition({
    Key key,
    @required Animation<double> turns,
    this.child,
  }) : super(key: key, listenable: turns);

  Animation<double> get turns => listenable;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double turnsValue = turns.value;
    final Matrix4 transform = new Matrix4.rotationY(turnsValue * math.pi * 2.0);
    return new Transform(
      transform: transform,
      alignment: Alignment.center,
      child: child,
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;
  Animation<Offset> moveAnimation;
  Animation<double> scaleAnimation;
  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    animation = Tween(begin: 0.0, end: 5.0).animate(_controller);
    scaleAnimation = Tween(begin: 0.0, end: -1.0).animate(_controller);
    moveAnimation =
        Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero)
            .animate(_controller);
    super.initState();
  }

  void callController() {
    animation = Tween(begin: 0.0, end: 15.0).animate(_controller);
    scaleAnimation = Tween(begin: 1.0, end: 0.3).animate(_controller);
    moveAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.0), end: Offset(0.0, -4.5))
            .animate(_controller);
    if (_controller.status == AnimationStatus.completed) {
      print('reverse');
      _controller.reverse();
    } else {
      print('forward');
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SlideTransition(
            position: moveAnimation,
             child:ScaleTransition(
              scale: scaleAnimation,
              child: RotationYTransition(
                turns: animation,
                child: Image.asset(
                  'assets/FlutterLogo2.jpg',
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: callController,
      ),
    );
  }
}
