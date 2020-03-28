import 'dart:io';

class Connection {
  final List<String> cmds = [];
  final List<String> fileManager=[];
  final Socket socket;

  Connection(this.socket);

  void getFiles(String path) {}
}
