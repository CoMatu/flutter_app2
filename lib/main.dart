import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app2/CharacteristListItem.dart';
import 'package:flutter_app2/FilesInDirectory.dart';

// run app
void main() => runApp(new MaterialApp(
    title: 'Характеристика',
    home: new CharacteristList(),
)
);

class CharacteristList extends StatefulWidget {

  @override
  _CharacteristListState createState() => new _CharacteristListState();
}

class _CharacteristListState extends State<CharacteristList> {
  List<String> filesList = new List<String>();
  List<String> filesL = new List<String>();
  @override

  void initState() {
    super.initState();
    filesList = [];
  }

  Future<List<String>> _getFilesFromDir() async{
    filesL = await FilesInDirectory().getFilesFromDir();
    setState(() {
      filesList = filesL;
    });
    return filesList;
  }

  @override
  Widget build(BuildContext context) {

    _getFilesFromDir();

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Список документов'),
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(
              child: new ListView.builder(
                //TODO не успевает сформировать список файлов
                itemCount: filesList.length,
                itemBuilder: (context, index){
                  return new CharacteristListItem(filesList[index]);
                },
              ),
          ),
          new RaisedButton(
              onPressed: (){

              },
            child: new Text('DATA'),
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context)
          => new StartScreen()),
          );},
        child: new Icon(Icons.add),
      ),
    );
  }

}


class StartScreen extends StatelessWidget {
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
                new Text('На следующей странице в раскрывающемся списке выберите одну или несколько компетенций для оценки. Для выбора нажмите "галочку", для отмены - повторное нажатие.',
                style: new TextStyle(
                  color: Colors.black87,
                  fontSize: 22.0
                ),),
                new Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: new RaisedButton(
                    child: new Text('Все понятно!',
                    style: new TextStyle(
                      fontSize: 16.0
                    ),),
                      onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(builder: (context) => new CharacteristicSkills()),
                    );
                  }),
                )
              ],
            ),

          ),
        ),
      );
  }
}

class CharacteristicSkills extends StatelessWidget {
  get context => context;

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
                    itemBuilder: (BuildContext context, int index) => new EntryItem(data[index]),
                    itemCount: data.length,
                  ),
              ),
              new RaisedButton(
                  onPressed: () {
                    if(character.length == 0){
                      showDialog(context: context,
                      builder: (BuildContext context){
                        return new AlertDialog(
                          title: new Text('ВНИМАНИЕ!',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            color: Colors.red
                          ),),
                          content: new Text('Не выбрано ни одного значения',
                          textAlign: TextAlign.center,),
                        );
                      });
                    } else
                    Navigator.push(
                      context,
                      new MaterialPageRoute(builder: (context) => new CharacterText()),
                    );
                  },
                child: new Text('Прочитать текст',
                style: new TextStyle(
                  fontSize: 16.0
                )),
              )
            ],
          ),
        ),
      );
  }
}

class EntryItem extends StatefulWidget {

  final Entry entry;
  const EntryItem(this.entry);
  @override
  _EntryItemState createState() {
    return new _EntryItemState(entry);
  }
}

class _EntryItemState extends State<EntryItem> {
  //TODO: Сделать условие для выбора только ОДНОГО чекбокса

  Entry entry;
  _EntryItemState(Entry entry){
    this.entry = entry;
  }

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty)
      return new Column(
        children: <Widget>[
          new CheckboxListTile(
            title: new Text(
              root.title,
              style: new TextStyle(fontSize: 14.0),
            ),
            value: root.isChecked,
            onChanged: (bool value) {
              setState(() {
                root.isChecked = value;
                charactToList(root);
              });
            },
          ),
          new Divider(height: 16.0, indent: 0.0),
        ],
      );
//      return new Divider();
    return new ExpansionTile(
      key: new PageStorageKey<Entry>(root),
      title: new Text(root.title),
      children: root.children.map(_buildTiles).toList()
    );
  }
  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
  void charactToList (Entry root){
    if(root.isChecked){
      character.add(root.title);
    }
    if(!root.isChecked){
      character.remove(root.title);
    }
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.isChecked, this.title, [this.children = const <Entry>[]]);
  final String title;
  List<Entry> children;
  bool isChecked;
}

// TODO Заполнить список деловых качеств
List<Entry> data = <Entry>[
  new Entry(false,
    ' Компетентность',
    <Entry>[
      new Entry(false,
          'Опыт работы и практические знания',
          <Entry>[
            new Entry(false,"Обладает исключительно большим опытом работы, большими практическими знаниями, такой опыт и такова практика имеются далеко не у каждого."),
            new Entry(false,"Обладает большим опытом работы и большими практическими знаниями."),
            new Entry(false,"Обладает достаточным опытом работы и практическими знаниями, чтобы успешно справляться с порученным делом."),
            new Entry(false,"Опыт работы и практические знания несколько маловаты."),
            new Entry(false,"Опыт работы и практические знания недостаточны для того, чтобы успешно справляться со своей работой."),
          ]),
      new Entry(false,'Знания по специальности', <Entry>[
        new Entry(false,"Имеет обширные и глубокие знания по своей специальности, широкую общую эрудицию в служебных вопросах. Умело использует свои знания в повседневной работе, может давать ценные консультации."),
        new Entry(false,"Имеет обширные и глубокие знания по своей специальности, может дать ценную консультацию. Однако, вопросах деятельности других служб ориентируется недостаточно."),
        new Entry(false,"Имеет хорошие знания по своей специальности, достаточную эрудицию в других служебных вопросах."),
        new Entry(false,"Имеет достаточные знания по своей специальности, однако в других служебных вопросах разбирается меньше."),
        new Entry(false,"Имеет достаточные знания по своей специальности, но совершенно отсутствует осведомленность по другим служебным вопросам."),
        new Entry(false,"Явно не достает знаний по своей специальности и совершенно отсутствует осведомленность в других вопросах."),
      ]),
      new Entry(false,'Самостоятельность', <Entry>[
        new Entry(false,"Может решать все вопросы, касавшиеся своей работы, совершенно самостоятельно, не ожидая чьей-либо подсказки или указания."),
        new Entry(false,"В основном может решать большинство вопросов, касающихся своей работы, самостоятельно, не ожидая подсказки или указания."),
        new Entry(false,"Может решать многие вопросы, касающиеся своей работы, более или менее самостоятельно."),
        new Entry(false,"Многие вопросы, связанные со своей работой, не может решать самостоятельно, нуждается в известной помощи, подсказках и указаниях."),
        new Entry(false,"Вопросы, связанные со своей работой, не может решать самостоятельно, нуждается в помощи, подсказках и указаниях."),
        new Entry(false,"Не может решать самостоятельно даже самые простые вопросы, связанные со своей собственной работой, постоянно нуждается в помощи, подсказках и указаниях."),
      ]),
      new Entry(false,'Самообразование', <Entry>[
        new Entry(false,"Постоянно, много и упорно занимается самообразованием по своей специальности и это очень положительно сказывается на работе."),
        new Entry(false,"Много и упорно занимается самообразованием по своей специальности и это заметно сказывается на улучшении работы."),
        new Entry(false,"Успешно сочетает работу с самообразованием по своей специальности."),
        new Entry(false,"Понимает пользу самообразования и по мере возможности стремится пополнить свои знания по избранной специальности."),
        new Entry(false,"Признает на словах необходимость самообразования, однако, никаких успехов в этом не заметно."),
        new Entry(false,"Отрицает необходимость самообразования, что не приносит пользы, делу."),
      ]),
    ],
  ),
  new Entry(false,
    'Работоспособность',
    <Entry>[
      new Entry(false,'Результативность', <Entry>[
        new Entry(false,"В своей работе постоянно добивается высоких результатов, своим примером воодушевляет коллег."),
        new Entry(false,"В своей работе постоянно добивается хороших результатов, вносит важный вклад в работу коллектива."),
        new Entry(false,"Работает ровно, без срывов, трудовая отдача соответствует предъявленным требованиям."),
        new Entry(false,"Работает неровно, наряду с успехами в служебной деятельности бывают и отдельные срывы."),
        new Entry(false,"Работает недостаточно интенсивно, не всегда добивается требуемых результатов, иногда допускает серьезные срывы."),
        new Entry(false,"Работает плохо. Результаты работы хронически не отвечают предъявленным требованиям."),
      ]),
      new Entry(false,'Отношение к работе', <Entry>[
        new Entry(false,"Очень любит свою работу, практически уделяет ей все свое свободное время и энергию."),
        new Entry(false,"Любит свою работу."),
        new Entry(false,"К своей работе относится добросовестно."),
        new Entry(false,"К своей работе относится равнодушно."),
        new Entry(false,"Не любит свою работу, но выполняет ее добросовестно."),
        new Entry(false,"Крайне не любит свою работу и повсюду говорит об этом."),
      ]),
      new Entry(false,'Интенсивность работы', <Entry>[
        new Entry(false,"В работе показывает очень высокую интенсивность, способность работать за пятерых."),
        new Entry(false,"В работе показывает высокую интенсивность."),
        new Entry(false,"В работе показывает достаточную интенсивность."),
        new Entry(false,"В работе показывает недостаточную интенсивность."),
        new Entry(false,"В работе показывает низкую интенсивность."),
        new Entry(false,"В работе показывает крайне низкую интенсивность, нуждается в постоянном понукании."),
      ]),
    ],
  ),
  new Entry(false,
    'Деловитость',
    <Entry>[
      new Entry(false,'Соблюдение сроков', <Entry>[
        new Entry(false,'Всегда все делает вовремя, всегда укладывается в срок, в связи с этим можно совершенно не беспокоиться.'),
        new Entry(false,'Обычно все делает вовремя и укладывается в срок - можно положиться.'),
        new Entry(false,'В основном порученные задания выполняет в срок и других товарищей не подводит.'),
        new Entry(false,'Не всегда выполняет порученную работу вовремя, иногда не укладывается в срок, но в особо ответственных случаях старается не подводить других товарищей.'),
        new Entry(false,'Часто при выполнении порученных заданий не укладывается в срок и подводит этим других товарищей.'),
        new Entry(false,'Постоянно не укладывается в срок и подводит этим других товарищей, на такого человека совершенно невозможно положиться.'),
      ]),
      new Entry(false,'Качество работы', <Entry>[
        new Entry(false,'Работает практически всегда без ошибок.'),
        new Entry(false,'Работает, в основном, без ошибок, если и допускает ошибки в работе, то они не отражаются на конечных результатах.'),
        new Entry(false,'Редко допускает в работе ошибки, как правило, лишь незначительные.'),
        new Entry(false,'Допускает в работе ошибки, и иногда это сказывается на конечных результатах.'),
        new Entry(false,'Часто допускает в работе ошибки, в тон числе и довольно грубые.'),
        new Entry(false,'Постоянно допускает в работе грубейшие ошибки.'),
      ]),
      new Entry(false,'Отношение к нововведениям',
        <Entry>[
          new Entry(false,'Любит различные нововведения и реорганизации. Но не любит работать в нормальном спокойном режиме.'),
          new Entry(false,'Порой излишне увлекается различными новшествами и реорганизациями в ущерб текущей работе.'),
          new Entry(false,'Стремится вовремя поддержать любое начинание.'),
          new Entry(false,'Может поддержать полезное начинание, хотя не особенно любит различные нововведения и реорганизации.'),
          new Entry(false,'Порой проявляет изливший консерватизм, не любит различных нововведений и реорганизаций.'),
          new Entry(false,'Проявляет крайний консерватизм, выступает против всякого нововведения.'),
        ],
      ),
    ],
  ),
];

List<String> character = new List();

class CharacterText extends StatefulWidget {

  @override
  _CharacterText createState() {
    return new _CharacterText();
  }

}

//Выводит на экран текст характеристики и кнопки записи
class _CharacterText extends State<CharacterText>{

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
                  itemBuilder: (context, index){
                    return new ListTile(
                      title: new Text(character[index]),
                    );
                  }),
            ),
            //TODO Ограничить количество символов названия файла
            new RaisedButton(
              onPressed: () {
                String filename = 'Введите имя файла:';
                showDialog(context: context,
                    builder: (BuildContext context){
                      return new AlertDialog(
                        title: new Text(filename),
                        content: new TextField(
                          controller: myController,
                          decoration: new InputDecoration(
                              hintText: 'имя файла'
                          ),
                        ),
                        actions: <Widget>[
                          new FlatButton(
                              onPressed: () => Navigator.pop(context),
                              child: new Text('Отмена',
                                style: new TextStyle(
                                    color: Colors.red
                                ),)
                          ),

                          //TODO сделать проверку занятости имени файла
                          new FlatButton(
                              onPressed: (){
                                String filename1 = myController.text;
                                print(filename1);
                                filenames.add(filename1);
                                String content = character.join("\n");
                                CharacteristicsStorage().writeCharacteristic(content);
                                Navigator.pop(context);
                              },
                              child: new Text('Сохранить'))
                        ],
                      );
                    }
                );
              },
              child: new Text('Сохранить в файл',
                style: new TextStyle(fontSize: 16.0),),
            )
          ],
        ),
      ),
    );
  }
  }
//TODO добавить функционал получения разрешений на запись и чтение

  //Запись в файл выбранных значений
class CharacteristicsStorage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path+'/user_data');

    return directory.path+'/user_data';
  }

  Future<File> get _localFile async {
    String filename = filenames.last+'.txt';
    final path = await _localPath;
    return new File('$path/$filename').create(recursive: true);
  }

  Future<String> readCharacteristic() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      return 'READING FILE ERROR';
    }
  }

  Future<File> writeCharacteristic(String content) async {

    final file = await _localFile;
    // Write the file
    return file.writeAsString('$content');
  }

}

final filenames = new List<String>();

