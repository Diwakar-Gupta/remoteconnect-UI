import 'dart:io';

class CmdConnector {
  final Socket socket;

  CmdConnector(this.socket);
  static Future<CmdConnector> getNew(String ip, int port) async {
    print("New Connection -> $ip:$port");
    Socket s = await Socket.connect(ip, port);
    s.writeln('terminal');
    return CmdConnector(s);
  }
}
