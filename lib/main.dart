import 'package:flutter/material.dart';
import 'package:nav2_demo/nav2_router.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      home: const Nav2RouterHome(),
    );
  }
}
