import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:florea/core/theme/app_theme.dart';
import 'package:florea/app/app_pages.dart';
import 'package:florea/app/app_routes.dart';
import 'package:florea/app/bindings/app_bindings.dart';

class SerenaApp extends StatelessWidget {
  const SerenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Serena',
      theme: AppTheme.light,
      initialRoute: Routes.login,
      getPages: AppPages.routes,
      initialBinding: AppBindings(),
      debugShowCheckedModeBanner: false,
    );
  }
}
