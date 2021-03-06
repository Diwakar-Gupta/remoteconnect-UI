import 'dart:io';

import 'package:remoteconnect/connector/interfac.dart';

class FileConnector extends Feature {
  final Socket socket;

  FileConnector(this.socket);
  static Future<FileConnector> getNew(String ip, int port,String path) async {
    print("New Connection -> $ip:$port");
    Socket s = await Socket.connect(ip, port);
    s.writeln('file');
    s.writeln(path);
    return FileConnector(s);
  }
}
