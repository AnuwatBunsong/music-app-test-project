import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/modules/home/bloc/home_bloc.dart';
import 'package:music/modules/home/views/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: MaterialApp(
        title: 'Music Play',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const Homepeage(),
      ),
    );
  }
}
