import 'package:flutter/material.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Colors.cyan.withOpacity(.6),
        title: Text("To-Do List"),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: WidgetAnimator(
        incomingEffect: WidgetTransitionEffects.incomingSlideInFromLeft(
            delay: Duration(
              seconds: 3,
            ),
            opacity: 5),
        atRestEffect: WidgetRestingEffects.size(),
        child: FloatingActionButton(
          onPressed:(){} ,
          isExtended: true,
          focusColor: Colors.black,
          focusElevation: 50,
          backgroundColor: Colors.cyan.withOpacity(.5),
        ),
      ),
    );
  }
}
