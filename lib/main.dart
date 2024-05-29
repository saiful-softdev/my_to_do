import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_to_do/db/db_helper.dart';
import 'package:my_to_do/to_do_screen.dart';

final dbHelper = DBHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        elevatedButtonTheme:ElevatedButtonThemeData(
    style: ElevatedButton
    .styleFrom(
    foregroundColor:
    Colors.white,
    minimumSize:
    const Size(0, 45),
    backgroundColor:
    Colors
    .greenAccent,
    shape:
    RoundedRectangleBorder(
    borderRadius:
    BorderRadius
    .circular(
    10),
    )

    ))),


      home: const ToDoScreen(),
    );
  }
}
