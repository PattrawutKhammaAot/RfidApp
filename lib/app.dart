import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rfid/blocs/master/master_rfid_bloc.dart';
import 'package:rfid/blocs/network/bloc/network_bloc.dart';
import 'package:rfid/blocs/scanrfid/scanrfid_code_bloc.dart';
import 'package:rfid/blocs/search_rfid/search_rfid_bloc.dart';
import 'package:rfid/blocs/tempMaster/temp_master_bloc.dart';
import 'package:rfid/config/appData.dart';
import 'package:rfid/main.dart';
import 'package:rfid/nativefunction/nativeFunction.dart';
import 'package:rfid/screens/homepage/homepageControl.dart';
import 'package:rfid/screens/scan/scanScreen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

enum FetchStatus {
  fetching,
  sending,
  success,
  failed,
  init,
  saved,
  sendSuccess,
  sendFailed,
  removeSuccess,
  importLoading,
  importFinish,
  importFailed,
  deleteSuccess,
  deleteAllSuccess,
  searchSuccess
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  Future<void> requestStoragePermission() async {
    try {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        if (await Permission.manageExternalStorage.request().isGranted) {
        } else {
          openAppSettings();
        }
      }
    } catch (e, s) {
      print("$e$s");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:

        // App is in background
        break;
      case AppLifecycleState.resumed:

        // App is resumed
        break;
      case AppLifecycleState.inactive:
        // App is inactive
        // await SDK_Function.openScanner();
        break;
      case AppLifecycleState.detached:
        // await SDK_Function.openScanner();
        // App is detached
        break;
      case AppLifecycleState.hidden:
      // await SDK_Function.openScanner();
      // TODO: Handle this case.
    }
  }
  // @override
  // void initState() {
  //   requestStoragePermission();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: requestStoragePermission(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiBlocProvider(providers: [
            BlocProvider<ScanrfidCodeBloc>(
              create: (_) => ScanrfidCodeBloc(),
            ),
            BlocProvider<SearchRfidBloc>(
              create: (_) => SearchRfidBloc(),
            ),
            BlocProvider<MasterRfidBloc>(
              create: (_) => MasterRfidBloc(),
            ),
            BlocProvider<TempMasterBloc>(
              create: (_) => TempMasterBloc(),
            ),
          ], child: AppView());
        } else {
          // Show a loading spinner or some other placeholder
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});
  static _AppViewState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppViewState>();

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final easyLoading = EasyLoading.init();
  Locale _locale = Locale('en');
  @override
  void initState() {
    AppData.getLocale().then((e) {
      if (e != null && e != '') {
        _locale = Locale(e);
      }
      setState(() {});
    });
    super.initState();
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      builder: (context, child) {
        appLocalizations = AppLocalizations.of(context)!;
        child = easyLoading(context, child);
        return child;
      },
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomePageControl(),
    );
  }
}
