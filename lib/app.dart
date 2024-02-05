import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rfid/blocs/network/bloc/network_bloc.dart';
import 'package:rfid/blocs/scanrfid/scanrfid_code_bloc.dart';
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
  importFailed
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => NetworkBloc()..add(NetworkObserve()),
      ),
      BlocProvider<ScanrfidCodeBloc>(
        create: (_) => ScanrfidCodeBloc(),
      ),
    ], child: AppView());
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
        child = BlocListener<NetworkBloc, NetworkState>(
          listener: (context, state) {
            if (state is NetworkFailure) {
              print("NetWorkFailed");
            } else if (state is NetworkSuccess) {
              print("NetWorkSuccess");
            }
          },
          child: child,
        );
        child = easyLoading(context, child);
        return child;
      },
      home: HomePageControl(),
    );
  }
}
