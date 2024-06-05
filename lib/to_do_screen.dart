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
    final widthSize = MediaQuery.of(context).size.width - 50;

    return FutureBuilder(
        future: dbHelper.queryAllRows(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text("Error : {$snapshot.error}"));
          } else {
            List<Map<String, dynamic>> data = snapshot.data ?? [];

            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                    toolbarHeight: 75,
                    backgroundColor: Colors.cyan.withOpacity(.6),
                    title: const Text(" Saiful To-Do List"),
                    centerTitle: true),
                floatingActionButtonAnimator:
                    FloatingActionButtonAnimator.scaling,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: WidgetAnimator(
                  incomingEffect:
                      WidgetTransitionEffects.incomingSlideInFromLeft(
                          delay: const Duration(seconds: 3), opacity: 5),
                  atRestEffect: WidgetRestingEffects.size(),
                  child: FloatingActionButton(
                    onPressed: () {
                      Get.dialog(
                          barrierDismissible: true,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Material(
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 8),
                                          const Text(
                                            "Todays To Do",
                                            textAlign: TextAlign.center,
                                          ),
                                          Column(children: [
                                            TextFormField(
                                                controller: _titleTEController,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: "Title")),
                                            TextFormField(
                                                controller: _textTEController,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: "To Do")),
                                            const SizedBox(height: 25)
                                          ]),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: const Text(
                                                          'Cancel'))),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        dbHelper.insert(
                                                            _titleTEController
                                                                .text,
                                                            _textTEController
                                                                .text);

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
                        // child: TextButton(onPressed: (){}, child:const Column(
                        //   children: [ my due task:+ icon ar nice add new ai lekata asbe
                        //     Icon(Icons.add),//render flex error dekai
                        //     Text("Add New ")
                        //   ],
                        // ) )
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ),
                ),
                body: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var item = data[index];

                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              width: widthSize,
                              margin: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.2),
                                  border:
                                      Border.all(color: Colors.black, width: 3),
                                  borderRadius: BorderRadius.circular(25)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Item no : ${index + 1}"),
                                    const SizedBox(height: 4),
                                    const Divider(
                                        thickness: 2,
                                        height: 0,
                                        color: Colors.black,
                                        endIndent: 10,
                                        indent: 10),
                                    ListTile(
                                      title: //Text([index].toString()),
                                          Text(item["todoTitle"].toString(),
                                              maxLines: 1),
                                      subtitle: //Text([index].toString())
                                          Text(item["todo"].toString(),
                                              maxLines: 2),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              height: 50,
                              width: widthSize,
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent,
                                  border:
                                      Border.all(width: 2, color: Colors.red),
                                  borderRadius: BorderRadius.circular(14)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        _titleEditTEController.text =
                                            item["todoTitle"];
                                        _textEditTEController.text =
                                            item["todo"];

                                        Get.dialog(
                                            barrierDismissible: true,
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 40),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: Material(
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(
                                                                height: 8),
                                                            const Text(
                                                              "Edit To Do",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            Column(children: [
                                                              TextFormField(
                                                                  controller:
                                                                      _titleEditTEController,
                                                                  decoration: const InputDecoration(
                                                                      labelText:
                                                                          "Title")),
                                                              TextFormField(
                                                                  controller:
                                                                      _textEditTEController,
                                                                  decoration: const InputDecoration(
                                                                      labelText:
                                                                          "To Do")),
                                                              const SizedBox(
                                                                  height: 25)
                                                            ]),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                    child: ElevatedButton(
                                                                        onPressed: () {
                                                                          Get.back();
                                                                        },
                                                                        child: const Text('Cancel'))),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Expanded(
                                                                    child: ElevatedButton(
                                                                        onPressed: () {

                                                                          setState(

                                                                              () {
                                                                            dbHelper.update(
                                                                                item["todoId"],
                                                                                _titleEditTEController?.text,
                                                                                _textEditTEController?.text);

                                                                          });
                                                                          Get.back();

                                                                        },
                                                                        child: const Text("Update")))
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
                                      child: const Text(
                                        "Edit",
                                        style: TextStyle(color: Colors.blue),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Get.dialog(
                                            barrierDismissible: true,
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 40),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: Material(
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(
                                                                height: 8),
                                                            const Text(
                                                              "Delete This To Do",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            const SizedBox(
                                                                height: 40),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                    child: ElevatedButton(
                                                                        onPressed: () {
                                                                          Get.back();
                                                                        },
                                                                        child: const Text('Cancel'))),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Expanded(
                                                                    child: ElevatedButton(
                                                                        onPressed: () {
                                                                          dbHelper
                                                                              .delete(item["todoId"]);

                                                                          Get.back();
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child: const Text("Confirm")))
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
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            );
          }
        });
  }


  String? textValidator(value) {
    if (value!.isEmpty) {
      return "Empty Field";
    }
    return null;
  }


}
