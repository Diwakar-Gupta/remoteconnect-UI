import 'dart:convert';

import 'package:flutter/material.dart';
import '../connector/cmd.dart';

class Cmd extends StatefulWidget {
  final CmdConnector connection;

  const Cmd({Key key, this.connection}) : super(key: key);
  @override
  _CmdState createState() => _CmdState();
}

class _CmdState extends State<Cmd> {
  final List<String> commands = [];

@override
void initState(){
  super.initState();
  widget.connection.socket.listen((event) { 
    setState(() {
      commands.add(ascii.decode(event));
    });
   });
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            child: ListView.builder(
              itemCount: commands.length,
              itemBuilder: (_, item) {
                return Text(
                  commands[item],
                  style: TextStyle(
                    fontSize: 18,
                  ),
                );
              }),
          ),
        ],
      ),
    );
  }
}
