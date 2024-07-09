import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/app.dart';
import 'package:rfid/database/database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late AppDb appDb;
late AppLocalizations appLocalizations;
void main() {
  appDb = AppDb();
  runApp(const App());
  WidgetsFlutterBinding.ensureInitialized();
}
