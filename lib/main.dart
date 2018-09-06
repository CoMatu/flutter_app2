import 'dart:async';
import 'package:flutter_app2/CharacteristListItem.dart';
import 'package:flutter_app2/FilesInDirectory.dart';
import 'package:flutter_app2/FileManager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'skills.dart';
import 'entry_model.dart';

final filenames = new List<String>();
List<String> character = new List();

// run app
void main() => runApp(new MaterialApp(
      title: 'Характеристика',
      home: new StartPage(),
    ));

class StartPage extends StatelessWidget {
  final String imageName = 'assets/letter.png';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(),
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'ХАРАКТЕРИСТИКА 1.0',
              style: new TextStyle(fontSize: 20.0),
            ),
            new Image.asset(imageName),
            new SizedBox(
              height: 40.0,
              width: 220.0,
              child: new RaisedButton(
                  elevation: 4.0,
                  color: Colors.orange,
                  highlightColor: Colors.orangeAccent,
                  child: new Text(
                    'К списку документов',
                    style: new TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          maintainState: false,
                          builder: (context) => new CharacteristList()),
                    );
                  }),
            ),
            new SizedBox(
              height: 16.0,
            ),
            new SizedBox(
              height: 40.0,
              width: 220.0,
              child: new RaisedButton(
                  elevation: 4.0,
                  color: Colors.orange,
                  highlightColor: Colors.orangeAccent,
                  child: new Text(
                    'Новая характеристика',
                    style: new TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    //TODO сделать обнулить все выборы чекбосков в списке перед созданием новой характеристики
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                          maintainState: false,
                          builder: (context) => new StartScreen()),
                    );
                  }),
            )
          ],
        ));
  }
}

// список сохраненных документов
class CharacteristList extends StatefulWidget {
  @override
  CharacteristListState createState() => new CharacteristListState();

  Widget customBuild(BuildContext context) {
    return new FutureBuilder(
        future: _inFutureList(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return new Text('загрузка...');
            default:
              if (snapshot.hasError)
                return new Text('ошибка получения списка документов');
              else
                return new Container(
                    child: new Expanded(
                  child: new ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return new CharacteristListItem(snapshot.data[index]);
                    },
                  ),
                ));
          }
        });
  }

  Future<List<String>> _inFutureList() async {
    var filesList = new List<String>();
    filesList = await FilesInDirectory().getFilesFromDir();
//    await new Future.delayed(new Duration(milliseconds: 500));
    return filesList;
  }
}

class CharacteristListState extends State<CharacteristList> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Список документов'),
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[widget.customBuild(context)],
        ),
      ),
      bottomNavigationBar: new CustomBottomAppBar(),
      floatingActionButton: new FloatingActionButton(
        elevation: 4.0,
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
                maintainState: false, builder: (context) => new StartScreen()),
          );
        },
        child: new Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class StartScreen extends StatelessWidget {
// TODO сделать чекбокс "не показывать больше"
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Характеристика'),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(18.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Image.asset('assets/letter.png'),
              new Text(
                'На следующей странице в раскрывающемся списке выберите '
                    'одну или несколько компетенций для оценки. Для выбора'
                    ' нажмите "галочку", для отмены - нажмите еще раз',
                textAlign: TextAlign.center,
                style: new TextStyle(color: Colors.black87, fontSize: 18.0),
              ),
              new Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: new SizedBox(
                    height: 40.0,
                    child: new RaisedButton(
                        elevation: 4.0,
                        color: Colors.orange,
                        highlightColor: Colors.orangeAccent,
                        child: new Text(
                          'Все понятно!',
                          style: new TextStyle(
                              fontSize: 18.0, color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                maintainState: false,
                                builder: (context) =>
                                    new CharacteristicSkills()),
                          );
                        }),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class CharacteristicSkills extends StatefulWidget {
  @override
  CharacteristicSkillsState createState() {
    return new CharacteristicSkillsState();
  }
}

class CharacteristicSkillsState extends State<CharacteristicSkills> {
  get context => context;
  Entry entry;

  void checkSkill(int value, Entry root) => setState(() {
        root.radioValue = value;
      });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Выберите деловые качества:'),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    _entryItemWidget(data[index]),
                itemCount: data.length,
              ),
            ),
            new SizedBox(
                height: 40.0,
                child: new RaisedButton(
                  elevation: 4.0,
                  color: Colors.orange,
                  highlightColor: Colors.orangeAccent,
                  onPressed: () {
                    if (character.length == 0) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return new AlertDialog(
                              title: new Text(
                                'ВНИМАНИЕ!',
                                textAlign: TextAlign.center,
                                style: new TextStyle(color: Colors.red),
                              ),
                              content: new Text(
                                'Не выбрано ни одного значения',
                                textAlign: TextAlign.center,
                              ),
                            );
                          });
                    } else
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            maintainState: false,
                            builder: (context) => new CharacterText()),
                      );
                  },
                  child: new Text('Прочитать текст',
                      style:
                          new TextStyle(fontSize: 18.0, color: Colors.white)),
                ))
          ],
        ),
      ),
    );
  }

  Widget _entryItemWidget(Entry root) {
    if (root.children.isEmpty) {
      return new Card(
        child: RadioListTile(
          key: new Key(root.title),
          groupValue: root.radioValue,
          title: new Text(
            root.title,
            style: new TextStyle(fontSize: 14.0),
          ),
          value: 1,
          onChanged: (value) {
            if(root.radioValue == 0){
              checkSkill(value, root);
              _charactToList(root, value);
            } else{
              print('характеристика выбрана');
              return null;
            }
            //TODO сделать условие выбора одного чекбокса
          },
        ),
      );
    }
    return new ExpansionTile(
        key: new PageStorageKey<Entry>(root),
        title: new Text(root.title),
        children: root.children.map(_entryItemWidget).toList());
  }
  void _charactToList(Entry root, int value) {
    if (value == 1) {
      character.add(root.title);
    }
  }

}

class CharacterText extends StatefulWidget {
  @override
  _CharacterText createState() {
    return new _CharacterText();
  }
}

//Выводит на экран текст характеристики и кнопки записи
class _CharacterText extends State<CharacterText> {
  final myController = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Характеристика'),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(14.0),
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new ListView.builder(
                  itemCount: character.length,
                  itemBuilder: (context, index) {
                    return new ListTile(
                      title: new Text(character[index]),
                    );
                  }),
            ),
            //TODO Ограничить количество символов названия файла
/*
            new RaisedButton(
              onPressed: () {
              },
              child: new Text('Сохранить в файл',
                style: new TextStyle(fontSize: 16.0),),
            )
*/
          ],
        ),
      ),
      bottomNavigationBar: CustomBABPage(),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          String filename = 'Введите имя файла:';
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return new AlertDialog(
                  title: new Text(filename),
                  content: new TextField(
                    controller: myController,
                    decoration: new InputDecoration(hintText: 'имя файла'),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: new Text(
                          'Отмена',
                          style: new TextStyle(color: Colors.red),
                        )),

                    //TODO сделать проверку занятости имени файла
                    new FlatButton(
                        onPressed: () {
                          String filename1 = myController.text;
                          print(filename1);
                          filenames.add(filename1);
                          String content = character.join("\n");
                          FileManager(filenames).writeCharacteristic(content);
                          Navigator.pop(context);
                        },
                        child: new Text('Сохранить'))
                  ],
                );
              });
        },
        child: new Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class CustomBABPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> rowContent = <Widget>[
      new IconButton(
          icon: const Icon(Icons.home),
          color: Colors.white,
          onPressed: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new StartPage()));
          }),
      new IconButton(
          icon: const Icon(Icons.mail),
          color: Colors.white,
          onPressed: () {
            _launchURL();
          })
    ];
    return new BottomAppBar(
      color: Colors.blue,
      child: new Row(children: rowContent),
    );
  }
}

// для отправки письма с текстом характеристики
_launchURL() async {
  String body = character.join("\n");
  var url = 'mailto:?'
      'subject=Текст характеристики - черновик' +
      '&body=' +
      body;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

//TODO добавить функционал получения разрешений на запись и чтение

class CustomBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> rowContent = <Widget>[
      new IconButton(
          icon: const Icon(Icons.menu), color: Colors.white, onPressed: () {}),
    ];
    return new BottomAppBar(
      color: Colors.blue,
      child: new Row(children: rowContent),
    );
  }
}

class BottomAppBarSavePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> rowContent = <Widget>[
      new IconButton(
          icon: const Icon(Icons.home), color: Colors.white, onPressed: () {}),
    ];
    return new BottomAppBar(
      color: Colors.blue,
      child: new Row(children: rowContent),
    );
  }
}

