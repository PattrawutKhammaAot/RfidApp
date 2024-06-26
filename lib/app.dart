import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rfid/blocs/master/master_rfid_bloc.dart';
import 'package:rfid/blocs/network/bloc/network_bloc.dart';
import 'package:rfid/blocs/scanrfid/scanrfid_code_bloc.dart';
import 'package:rfid/blocs/search_rfid/search_rfid_bloc.dart';
import 'package:rfid/blocs/tempMaster/temp_master_bloc.dart';
import 'package:rfid/screens/homepage/homepageControl.dart';
import 'package:rfid/screens/scan/scanScreen.dart';

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

class _AppState extends State<App> {
  Future<void> requestStoragePermission() async {
    try {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        // ขออนุญาต
        if (await Permission.manageExternalStorage.request().isGranted) {
          // ได้รับอนุญาต
          print("Manage external storage permission granted.");
        } else {
          // ไม่ได้รับอนุญาต
          print("Manage external storage permission denied.");
          openAppSettings();
        }
      } else {
        // มีสิทธิ์แล้ว
        print("Manage external storage permission already granted.");
      }
    } catch (e, s) {
      print("$e$s");
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

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final easyLoading = EasyLoading.init();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        child = easyLoading(context, child);
        return child;
      },
      home: HomePageControl(),
    );
  }
}
