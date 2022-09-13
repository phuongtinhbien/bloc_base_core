import 'dart:io';

import 'package:bloc_base_core/bloc_base_core.dart';
import 'package:example/app/app_config.dart';
import 'package:example/app/init_app.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfig.init(BuildMode.demo);
  runApp(const InitApp());
}