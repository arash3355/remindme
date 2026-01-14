import 'package:flutter/material.dart';
import 'routes/routes.dart';

class RemindMeApp extends StatelessWidget {
  const RemindMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'RemindMe',
      routerConfig: appRouter,
    );
  }
}
