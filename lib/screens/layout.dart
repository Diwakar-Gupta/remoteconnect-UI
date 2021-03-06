import 'package:flutter/material.dart';
import 'package:remoteconnect/connector/cmd.dart';
import 'package:remoteconnect/connector/connection.dart';
import 'package:remoteconnect/connector/fileconnection.dart';
import 'package:remoteconnect/connector/statusconnector.dart';
import 'package:remoteconnect/features/cmd.dart';
import 'package:remoteconnect/features/removeWidget.dart';
import 'package:remoteconnect/screens/status.dart';
import 'cmd.dart';
import 'filehandler.dart';

class Layout extends StatefulWidget {
  final Connection connection;

  const Layout({Key key, this.connection}) : super(key: key);
  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> with TickerProviderStateMixin , AutomaticKeepAliveClientMixin {
  TabController _cardController;
  TabPageSelector _tabPageSelector;

  final List<Widget> list = [];

  @override
  void initState() {
    super.initState();

    for(var i in widget.connection.features){
      if(i is StatusConnector)
      list.add(Status(status: i));
      if(i is CmdConnector)
      list.add(Cmd(connection: i));
      if(i is FileConnector)
      list.add(FileHandler(connector: i));
      
    }

    _cardController = new TabController(vsync: this, length: list.length);
    _tabPageSelector = new TabPageSelector(controller: _cardController);
  }

  void dynamicAddTab(Widget w) {
    disposee();
    setState(() {
      list.add(w);
      _cardController = new TabController(vsync: this, length: list.length);
      _tabPageSelector = new TabPageSelector(controller: _cardController);
    });
  }

  void dynamicRemoveTab(Widget w) {
    disposee();
    setState(() {
      list.remove(w);
      _cardController = new TabController(vsync: this, length: list.length);
      _tabPageSelector = new TabPageSelector(controller: _cardController);
    });
  }

  void disposee() {
    _cardController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('title'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10.0),
            child: new Theme(
              data: Theme.of(context).copyWith(accentColor: Colors.grey),
              child: list.isEmpty
                  ? new Container(
                      height: 30.0,
                    )
                  : new Container(
                      height: 30.0,
                      alignment: Alignment.center,
                      child: _tabPageSelector,
                    ),
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  dynamicAddTab(Cmd());
                })
          ]),
      body: NotificationListener<AddCmd>(
        onNotification: (ac) {
          CmdConnector.getNew(widget.connection.socket.remoteAddress.address,
                  widget.connection.socket.remotePort)
              .then((value) => dynamicAddTab(Cmd(connection: value)));
          return true;
        },
        child: TabBarView(
          controller: _cardController,
          children: list
              .map((e) => (e is Cmd)
                  ? Stack(
                      children: <Widget>[
                        e,
                        Positioned(
                            top: 5,
                            right: 5,
                            child: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  dynamicRemoveTab(e);
                                }))
                      ],
                    )
                  : (e is FileHandler)
                      ? NotificationListener<Close>(
                          onNotification: (_) {
                            dynamicRemoveTab(e);
                            return true;
                          },
                          child: e,
                        )
                      : e)
              .toList(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
