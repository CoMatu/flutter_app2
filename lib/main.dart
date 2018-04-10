import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Выберите компетенцию:'),
        ),
        body: new ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              new EntryItem(data[index]),
          itemCount: data.length,
        ),
      ),
    );
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);
  final String title;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  new Entry(
    ' Компетентность',
    <Entry>[
      new Entry(
        'Опыт работы и практические знания',
        <Entry>[
          new Entry("Обладает исключительно большим опытом работы, большими "
              "практическими знаниями, такой опыт и такова практика имеются "
              "далеко не у каждого."),
          new Entry("Обладает большим опытом работы и большими практическими "
              "знаниями."),
          new Entry("Обладает достаточным опытом работы и практическими "
              "знаниями, чтобы успешно справляться с порученным делом."),
          new Entry("Опыт работы и практические знания несколько маловаты."),
          new Entry("Опыт работы и практические знания недостаточны для того, "
              "чтобы успешно справляться со своей работой."),
        ],
      ),
      new Entry('Знания по специальности'),
      new Entry('Самостоятельность'),
      new Entry('Самообразование'),
      new Entry('Вопросы бухгалтерского учета и отчетности'),
      new Entry('Правовые знания'),
      new Entry('Управление документооборотом'),
    ],
  ),
  new Entry(
    'Работоспособность',
    <Entry>[
      new Entry('Section B0'),
      new Entry('Section B1'),
    ],
  ),
  new Entry(
    'Деловитость',
    <Entry>[
      new Entry('Section C0'),
      new Entry('Section C1'),
      new Entry(
        'Section C2',
        <Entry>[
          new Entry('Item C2.0'),
          new Entry('Item C2.1'),
          new Entry('Item C2.2'),
          new Entry('Item C2.3'),
        ],
      ),
    ],
  ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty)
      return new Column(
        children: <Widget>[
          new CheckboxListTile(
            title: new Text(root.title, style: new TextStyle(fontSize: 14.0),),
//          activeColor: Colors.white,
            value: timeDilation != 1.0,
            onChanged: (bool value) {
              setState(() {
                timeDilation = value ? 20.0 : 1.0;
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
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }

  void setState(Function param0) {}
}
