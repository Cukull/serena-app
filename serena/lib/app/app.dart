import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:serena/app/app_pages.dart';
import 'package:serena/app/app_routes.dart';
import 'package:serena/app/bindings/app_bindings.dart';
import 'package:serena/core/theme/app_theme.dart';

class SerenaApp extends StatelessWidget {
  const SerenaApp({super.key, this.initialRoute = Routes.landing});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Serena',
      theme: AppTheme.light,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      initialBinding: AppBindings(),
      debugShowCheckedModeBanner: false,
    );
  }
}
