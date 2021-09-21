import 'package:data_connection_checker/data_connection_checker.dart';
import 'dart:async';

class DataConnectivityService {
  StreamController<DataConnectionStatus> connetivityStreamController =
      StreamController<DataConnectionStatus>();
  DataConnectivityService(){
    DataConnectionChecker().onStatusChange.listen((dataConnectionStatus) {
      connetivityStreamController.add(dataConnectionStatus);
    });
  }
}