import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:remoteconnect/connector/FileManager.dart';
import 'package:remoteconnect/features/cmd.dart';
import 'package:remoteconnect/features/fileOperations.dart';
import 'package:remoteconnect/features/removeWidget.dart';

class FileHandler extends StatefulWidget {
  final String path;
  final FileConnector connector;

  const FileHandler({Key key, this.path, this.connector}) : super(key: key);
  @override
  _FileHandlerState createState() => _FileHandlerState();
}

class _FileHandlerState extends State<FileHandler> {
  final List<List<String>> files = [];
  var short = false;
  List<String> pathSeperated;

  @override
  void initState() {
    super.initState();
    pathSeperated = widget.path.split('/');
    pathSeperated[0] = '/';
    print('created at path: ${widget.path}');
  }

  @override
  Widget build(BuildContext context) {
    files.clear();
    files.addAll([
      ['file.txt', 'false'],
      ['folder', 'true']
    ]);

    return NotificationListener<FileDirectory>(
      onNotification: (not) {
        not.add(widget.path);
        return false;
      },
      child: NotificationListener<Delete>(
        onNotification: (not) {
          print('Delete file : ${not.file}');
          return true;
        },
        child: NotificationListener<Run>(
          onNotification: (not) {
            not.add(widget.path);
            return false;
          },
          child: NotificationListener<RunInTerminal>(
            onNotification: (not) {
              print('RunInTerminal file : ${not.file}');
              return true;
            },
            child: NotificationListener<RenameFile>(
              onNotification: (not) {
                print('Rename file : ${not.previousName} -> ${not.newName}');
                return true;
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              String s = '';
                              for (int j = 1; j < pathSeperated.length - 1; j++)
                                s = s + '/' + pathSeperated[j];

                              FileDirectory(s).dispatch(context);
                            }),
                        Expanded(
                            child: Container(
                          color: Colors.red,
                          child: Row(
                            children: <Widget>[
                              ChoiceChip(label: Text('data'), selected: false)
                            ],
                          ),
                        )),
                        Row(
                          children: <Widget>[
                            IconButton(
                                icon: Icon((short)
                                    ? Icons.view_list
                                    : Icons.view_module),
                                onPressed: () {
                                  setState(() {
                                    short = !short;
                                  });
                                }),
                            PopupMenuButton(
                                onSelected: (i) {
                                  switch (i) {
                                    case -1:
                                      Close(widget).dispatch(context);
                                      break;
                                    case 0:
                                      showDialog(
                                          barrierDismissible: true,
                                          context: context,
                                          child: AlertDialog(
                                              content: RaisedButton(
                                            onPressed: () {
                                              print('file choosed');
                                              Navigator.pop(context);
                                            },
                                            child: Text('ChooseFile'),
                                          )));
                                      break;

                                    case 2:
                                      AddCmd().dispatch(context);
                                      break;

                                    default:
                                  }
                                },
                                child: Icon(Icons.more_vert),
                                itemBuilder: (_) => [
                                      PopupMenuItem(
                                          value: 0, child: Text('Upload')),
                                      PopupMenuItem(
                                        value: 2,
                                        child: Text('Terminal'),
                                      ),
                                      PopupMenuItem(
                                        value: -1,
                                        child: Text('Close'),
                                      )
                                    ]),
                          ],
                        )
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          children: files
                              .map((e) => File(
                                  name: e[0],
                                  short: short,
                                  directory: e[1] == 'true',
                                  fileHandler: widget))
                              .toList(),
                          spacing: 15,
                          runSpacing: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class File extends StatelessWidget {
  final String name;
  final bool short;
  final bool directory;
  final FileHandler fileHandler;

  const File(
      {Key key,
      this.name,
      this.directory,
      this.short = false,
      this.fileHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String nam = name;
    final List<PopupMenuItem> actions = [];

    if (!directory) {
      actions.addAll([
        PopupMenuItem(value: 0, child: Text('run')),
        PopupMenuItem(value: 1, child: Text('run in terminal')),
      ]);
    }
    actions.addAll([
      PopupMenuItem(value: 1, child: Text('Open Terminal')),
      PopupMenuItem(value: 3, child: Text('Download')),
      PopupMenuItem(value: 4, child: Text('Rename')),
      PopupMenuItem(value: 5, child: Text('Delete'))
    ]);

    void reName() {
      print('saving file as ' + nam);
      Navigator.pop(context);
    }

    var pop = PopupMenuButton(
        onSelected: (i) {
          switch (i) {
            case 0:
              Run(name).dispatch(context);
              break;
            case 1:
              RunInTerminal(name).dispatch(context);
              break;
            case 3:
              Download(name).dispatch(context);
              break;

            case 4:
              showDialog(
                  barrierDismissible: true,
                  context: context,
                  child: AlertDialog(
                    content: TextFormField(
                      onChanged: (s) {
                        nam = s;
                      },
                      onEditingComplete: reName,
                      initialValue: name,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(Icons.done),
                              onPressed: () {
                                print('dispatching rename');
                                RenameFile(name, nam).dispatch(context);
                                Navigator.pop(context);
                              })),
                      autofocus: true,
                    ),
                  ));
              break;
            case 5:
              Delete(name).dispatch(context);
              break;
            default:
          }
        },
        child: Icon(Icons.more_vert),
        itemBuilder: (_) => actions);

    if (short)
      return Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Icon(
                  (directory) ? Icons.folder : FontAwesomeIcons.file,
                  size: 80,
                ),
                Positioned(top: 15, right: 2, child: pop)
              ],
            ),
            Text(name)
          ],
        ),
      );
    return ListTile(
      onTap: (directory)
          ? () {
              FileDirectory(name).dispatch(context);
            }
          : null,
      leading: Icon((directory) ? Icons.folder : FontAwesomeIcons.file),
      title: Text(name),
      trailing: pop,
    );
  }
}
