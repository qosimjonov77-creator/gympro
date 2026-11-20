import 'package:flutter/material.dart';
import 'app/router.dart';
import 'app/theme.dart';

void main() => runApp(const GymProMember());

class GymProMember extends StatelessWidget {
  const GymProMember({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'GymPro Member',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        routerConfig: router,
      );
}
