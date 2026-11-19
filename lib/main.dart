import 'package:flutter/material.dart';
import 'app/router.dart';
import 'app/theme.dart';

void main() => runApp(const GymProAdmin());

class GymProAdmin extends StatelessWidget {
  const GymProAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GymPro Admin',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      routerConfig: router,
    );
  }
}
