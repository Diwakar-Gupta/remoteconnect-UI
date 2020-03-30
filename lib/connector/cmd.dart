import 'dart:convert';
import 'dart:io';
import 'package:remoteconnect/connector/interfac.dart';

class CmdConnector extends Feature {
  final Socket socket;
  final List<String> commands = [];
  void Function(String) child;

  CmdConnector(this.socket) {
    child = null;
    socket.listen((event) {
      if(child !=null)
      child(ascii.decode(event));
      print(ascii.decode(event));
    });
  }
  bool send(String s){
    socket.writeln(s);
    return true;
  }
  static Future<CmdConnector> getNew(String ip, int port) async {
    print("New Connection -> $ip:$port");
    Socket s = await Socket.connect(ip, port);
    s.writeln('terminal');

    return CmdConnector(s);
  }
}
