import 'package:flutter/cupertino.dart';

class RenameFile extends Notification {
  final String previousName;
  final String newName;

  RenameFile(this.previousName, this.newName);
}

class Delete extends Notification {
  final String file;

  Delete(this.file);
}

class Run extends Notification {
  String _path;

  Run(this._path);
    String getPath() => _path;
  void add(String s) {
    if (s == '/')
      _path = '/' + _path;
    else
      _path = s + '/' + _path;
  }
}

class RunInTerminal extends Notification {
  bool isDirectory;
  final String file;

  RunInTerminal(this.file);
}

class Download extends Notification {
  final String file;

  Download(this.file);
}

class Upload extends Notification {}

class FileDirectory extends Notification {
  String _path;

  FileDirectory(this._path);
  String getPath() => _path;
  void add(String s) {
    if (s == '/')
      _path = '/' + _path;
    else
      _path = s + '/' + _path;
  }
}
