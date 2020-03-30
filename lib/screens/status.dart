import 'package:flutter/material.dart';
import 'package:remoteconnect/connector/statusconnector.dart';
import 'package:remoteconnect/features/cmd.dart';

class Status extends StatefulWidget {
  final StatusConnector status;

  const Status({Key key, this.status}) : super(key: key);
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  int volume = 3;
  int brightness = 3;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon((brightness==0)?Icons.brightness_low:(brightness==10)?Icons.brightness_high:Icons.brightness_medium),
            Slider(
              value: brightness / 10,
              onChanged: (d) {
                setState(() {
                  brightness = (d * 10).toInt();
                });
              },
              min: 0,
              max: 1,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(Icons.speaker),
            Slider(
              value: volume / 10,
              onChanged: (d) {
                setState(() {
                  volume = (d * 10).toInt();
                });
              },
              min: 0,
              max: 1,
            )
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 60,
                height: 60,
                child: IconButton(icon: Icon(Icons.lock), onPressed: () {}),
                color: Colors.blue,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 60,
                height: 60,
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    AddCmd().dispatch(context);
                  },
                ),
                color: Colors.blue,
              ),
            ),
          ],
        )
      ],
    );
  }
}
