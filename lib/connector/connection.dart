import 'dart:collection';
import 'dart:convert';
import 'dart:io';

class Connection {
  final List<String> cmds = [];
  final List<String> fileManager = [];
  final Socket socket;
  final Queue<String> commands = Queue();

  Connection(this.socket) {
    socket.listen((event) {
      commands.add(ascii.decode(event));
    });
  }

  Iterable<String> next({int count = 1}) {
    return commands.isEmpty ? null : commands.take(count);
  }

  void getFiles(String path) {}
}
