import 'package:flutter/material.dart';
import 'util.dart';
import 'theme.dart';
import 'pages/cities_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, 'Quicksand', 'Fredoka');
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Sims Companion',
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: ThemeMode.dark, 
      initialRoute: "/",
      routes: {
        "/": (context) => const CitiesPage(),
      },
    );
  }
}