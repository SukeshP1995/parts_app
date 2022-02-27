import 'package:parts_app/set_checkpoint.dart';

import 'main_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? checkpoint = prefs.getString("checkpoint");

  runApp(MaterialApp(home: (checkpoint != null) ?  MainPage() : SetCheckpointPage()));
}
