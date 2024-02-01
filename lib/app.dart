import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rfid/blocs/network/bloc/network_bloc.dart';
import 'package:rfid/screens/scan/scanScreen.dart';

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
      )
    ], child: AppView());
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
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
        return child;
      },
      home: ScanScreen(),
    );
  }
}
