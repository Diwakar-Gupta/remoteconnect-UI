import 'dart:io';
import 'package:flutter/material.dart';

class ConnectPc extends Notification {
  final Socket connection;

  ConnectPc(this.connection);
}
