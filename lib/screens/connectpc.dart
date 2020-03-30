import 'dart:io';
import 'package:flutter/material.dart';
import 'package:remoteconnect/features/addpc.dart';

class AddPc extends StatefulWidget {
  static var ip = '127.0.0.1';
  static var port = 9952;

  @override
  _AddPcState createState() => _AddPcState();
}

class _AddPcState extends State<AddPc> {
  bool waiting = false;
  final ipControl =
      InputDecoration(hintText: '192.16.16.16', labelText: 'label');
  final portControl = InputDecoration(hintText: '9952', labelText: 'Port');
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        child: Column(
          children: <Widget>[
            Flexible( child: Container()),
            Container(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: AddPc.ip,
                    decoration: ipControl,
                  ),
                  TextFormField(
                    initialValue: AddPc.port.toString(),
                    decoration: portControl,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        waiting = true;
                      });
                      try {
                        Socket.connect(AddPc.ip, AddPc.port.toInt())
                            .timeout(Duration(seconds: 4), onTimeout: () {
                          setState(() {
                            waiting = false;
                          });
                          return null;
                        }).then((value){value.writeln('pc');ConnectPc(value).dispatch(context);});
                      } catch (_) {
                        setState(() {
                          waiting = false;
                        });
                      }
                    },
                    child: (waiting)
                        ? CircularProgressIndicator()
                        : Text('Connect'),
                  ),
                  (error == null || null == '') ? Container() : Text(error)
                ],
              ),
            ),
            Flexible(child: Container())
          ],
        ),
      ),
    );
  }
}
