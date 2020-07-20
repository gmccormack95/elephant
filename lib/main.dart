import 'package:elephant/bloc/habit_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pages/home.dart';
import 'widget/remove_glow.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HabitBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: RemoveGlow(),
            child: MediaQuery(
              child: child,
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0)
            )
          );
        },
      ),
    );
  }
}
