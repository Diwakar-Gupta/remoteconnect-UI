import 'package:flutter/material.dart';
import '../connector/cmd.dart';

class Cmd extends StatefulWidget {
  final CmdConnector connection;
  StreamBuilder sb;

  Cmd({Key key, this.connection}) {
    print('Cmd created');
  }
  @override
  _CmdState createState() => _CmdState();
}

class _CmdState extends State<Cmd> {
  @override
  void initState() {
    super.initState();
    widget.connection.child = refresh;
  }

  void refresh(String s) {
    if (s != '')
      setState(() {
        widget.connection.commands.add(s);
      });
  }

  @override
  void dispose() {
    print('disposed');
    widget.connection.child = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: ListView(
                children:
                    widget.connection.commands.map((e) => Text(e)).toList(),
              ),
            ),
            ListTile(
              title: TextField(
                onSubmitted: (s) {
                  if (widget.connection.send(s))
                    setState(() {
                      widget.connection.commands.add(s);
                    });
                },
                decoration: InputDecoration(
                  hintText: 'command'
                ),
              ),
              //trailing: Container(width: 40,child: FlatButton(onPressed: () {},child: Icon(Icons.send,))),
            )
          ],
        ));
  }
}
