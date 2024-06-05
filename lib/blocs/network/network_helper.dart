// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:rfid/blocs/network/bloc/network_bloc.dart';

// class NetworkHelper {
//   static void observeNetwork() {
//     Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//       if (result == ConnectivityResult.none) {
//         NetworkBloc().add(NetworkNotify());
//       } else {
//         NetworkBloc().add(NetworkNotify(isConnected: true));
//       }
//     });
//   }
// }
