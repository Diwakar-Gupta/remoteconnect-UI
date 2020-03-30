import 'dart:collection';
import 'dart:io';
import 'package:remoteconnect/connector/interfac.dart';
import 'package:remoteconnect/connector/statusconnector.dart';


class Connection {
  final List<Feature> features = [];
  final Socket socket;
  final Queue<String> commands = Queue();

  Connection(this.socket) {
    features.add(StatusConnector(socket));
  }
}
