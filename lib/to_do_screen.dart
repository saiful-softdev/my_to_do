import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_to_do/db/db_helper.dart';
import 'package:my_to_do/main.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  @override
  void initState() {
    super.initState();
    final dbHelper = DBHelper();
    dbHelper.init();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _titleTEController = TextEditingController();
    final TextEditingController _textTEController = TextEditingController();
    final TextEditingController _titleEditTEController =
    TextEditingController();
    final TextEditingController _textEditTEController = TextEditingController();
    return FutureBuilder(
        future: dbHelper.queryAllRows(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error : {$snapshot.error}"),
            );
          } else {
            List<Map<String, dynamic>> data = snapshot.data ?? [];

            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 75,
                backgroundColor: Colors.cyan.withOpacity(.6),
                title: const Text("To-Do List"),
              ),
              floatingActionButtonAnimator:
              FloatingActionButtonAnimator.scaling,
              floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
              floatingActionButton: WidgetAnimator(
                incomingEffect: WidgetTransitionEffects.incomingSlideInFromLeft(
                    delay: Duration(seconds: 3), opacity: 5),
                atRestEffect: WidgetRestingEffects.size(),
                child: FloatingActionButton(
                  onPressed: () {
                    Get.dialog(
                        barrierDismissible: true,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Material(
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 8),
                                        const Text(
                                          "Todays To Do",
                                          textAlign: TextAlign.center,
                                        ),
                                        Column(
                                            children: [
                                              TextFormField(
                                                  controller: _titleTEController,
                                                  maxLines: 1,
                                                  decoration: const InputDecoration(
                                                      labelText: "Title")
                                              ),
                                              TextFormField(
                                                  controller: _textTEController,
                                                  decoration: const InputDecoration(
                                                      labelText: "To Do")
                                              ),
                                              const SizedBox(height: 25),
                                            ]
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child:
                                                    const Text('Cancel'))),
                                            const SizedBox(width: 5),
                                            Expanded(
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      dbHelper.insert(
                                                          _titleTEController
                                                              ?.text,
                                                          _textTEController
                                                              ?.text);

                                                      Get.back();
                                                      setState(() {});
                                                    },
                                                    child: const Text("Add")))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ));
                  },
                  isExtended: true,
                  focusColor: Colors.black,
                  focusElevation: 50,
                  backgroundColor: Colors.cyan.withOpacity(.5),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ),
              ),
              body: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    var item = data[index];
                    _titleEditTEController.text = item["todoTitle"];
                    _textEditTEController.text = item["todo"];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                            height: 150,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 130,
                            margin: const EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                                color: Colors.amberAccent.withOpacity(.6),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(25)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Item no : $index"),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const Divider(
                                    thickness: 2,
                                    height: 0,
                                    color: Colors.black,
                                    endIndent: 10,
                                    indent: 10,
                                  ),
                                  ListTile(
                                    title: //Text([index].toString()),
                                    Text(item["todoTile"].toString(),
                                        maxLines: 1),
                                    subtitle: //Text([index].toString())
                                    Text(item["todo"].toString(),
                                        maxLines: 2),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 105,
                            width: 70,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent,
                                border: Border.all(width: 2, color: Colors.red),
                                borderRadius: BorderRadius.circular(14)),
                            child: Column(
                              children: [
                                TextButton(
                                    onPressed: () {},
                                    child: const Text("Edit")),
                                TextButton(
                                    onPressed: () {},
                                    child: const Text("Delete")),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            );
          }
        });
  }
}
