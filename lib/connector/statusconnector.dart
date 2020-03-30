import 'dart:io';

import 'package:remoteconnect/connector/interfac.dart';

class StatusConnector extends Feature {
  final Socket socket;
  StatusConnector(this.socket);
}
