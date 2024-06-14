import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/app.dart';
import 'package:rfid/database/database.dart';

late AppDb appDb;
void main() {
  appDb = AppDb();
  runApp(const App());
  WidgetsFlutterBinding.ensureInitialized();
}
