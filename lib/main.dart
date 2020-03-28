import 'package:flutter/material.dart';
import 'package:remoteconnect/connector/connection.dart';
import 'features/addpc.dart';
import 'screens/connectpc.dart';
import 'screens/layout.dart';

void main() {
  runApp(MyApp());
}

final themes = {
  "light": ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    accentColor: Colors.cyan,
    iconTheme: IconThemeData(color: Colors.blueAccent),
    fontFamily: 'Gilroy',
  ),
  "dark": ThemeData(
    brightness: Brightness.dark,
    //primaryColor: Colors.lightBlue[800], //(f7f7f)
    //accentColor: Colors.cyan[600],
  ),
};

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var theme = "dark";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themes[theme],
      home: NotificationListener<ChangeTheme>(
        onNotification: (t) {
          setState(() {
            theme = t.theme;
          });
          return true;
        },
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Connection> connectedPc = [];
  Connection pcShow;

  @override
  void initState(){
    super.initState();
    pcShow = null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: (pcShow != null)
            ? Layout(connection: pcShow) //Layout(connection: Connection(null))
            : NotificationListener<ConnectPc>(
                onNotification: (v) {
                  final val = Connection(v.connection);
                  connectedPc.add(val);
                  setState(() {
                    pcShow = val;
                  });
                  return true;
                },
                child: AddPc()),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              for (var i in connectedPc)
                ListTile(
                  title: Text('pc 1'),
                  leading: Icon(Icons.cast_connected),
                  onTap: () {
                    setState(() {
                      pcShow = i;
                    });
                    Navigator.pop(context);
                  },
                ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('add Computer'),
                onTap: () {
                  setState(() {
                    pcShow = null;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    ChangeTheme('light').dispatch(context);
                  });
                },
                title: Text('Light'),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    ChangeTheme('dark').dispatch(context);
                  });
                },
                title: Text('Dark'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeTheme extends Notification {
  final String theme;
  ChangeTheme(this.theme);
}
