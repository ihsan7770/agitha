import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NetworkService {
  static final Connectivity _connectivity = Connectivity();

  // Stream that emits true = internet, false = no internet
  static Stream<bool> get internetStatusStream async* {
    final result = await _connectivity.checkConnectivity();
    yield result != ConnectivityResult.none;

    await for (final event in _connectivity.onConnectivityChanged) {
      yield event != ConnectivityResult.none;
    }
  }



  Future<ListResult?> safeStorageCall() async {
  try {
    return await FirebaseStorage.instance.ref().listAll();
  } on SocketException {
    return null; // internet issue
  } catch (e) {
    return null;
  }
}
}
