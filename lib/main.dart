import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_app2/CharacteristListItem.dart';
import 'package:flutter_app2/FilesInDirectory.dart';
import 'package:flutter_app2/FileManager.dart';
import 'package:url_launcher/url_launcher.dart';

final filenames = new List<String>();
List<String> character = new List();

// run app
void main() => runApp(new MaterialApp(
    title: 'Характеристика',
    home: new StartPage(),
)
);

class StartPage extends StatelessWidget {
  var imagename = 'assets/letter.png';

  @override
  Widget build(BuildContext context) {

          return new Scaffold(
            appBar: new AppBar(),
            body: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text('ХАРАКТЕРИСТИКА 1.0',
                  style: new TextStyle(
                      fontSize: 20.0
                  ),),
                new Image.asset(imagename),
                new SizedBox(
                  height: 40.0,
                  width: 220.0,
                  child: new RaisedButton(
                      elevation: 4.0,
                      color: Colors.orange,
                      highlightColor: Colors.orangeAccent,
                      child: new Text('К списку документов',
                        style: new TextStyle(
                            color: Colors.white
                        ),),
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              maintainState: false,
                              builder: (context) => new CharacteristList()),
                        );
                      }),
                ),
                new SizedBox(height: 16.0,),
                new SizedBox(
                  height: 40.0,
                  width: 220.0,
                  child: new RaisedButton(
                      elevation: 4.0,
                      color: Colors.orange,
                      highlightColor: Colors.orangeAccent,
                      child: new Text('Новая характеристика',
                        style: new TextStyle(
                            color: Colors.white
                        ),),
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
            )

          );
  }
}

class CharacteristList extends StatefulWidget {

  @override
  CharacteristListState createState() => new CharacteristListState();

  Widget customBuild(BuildContext context){
    return new FutureBuilder(
        future: _inFutureList(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
            return new Text('загрузка...');
            default:
              if(snapshot.hasError)
                return new Text('ошибка получения списка документов');
              else
                return new Container(
                    child: new Expanded(
                      child: new ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index){
                          return new CharacteristListItem(snapshot.data[index]);
                        },
                      ),
                    )
                );
          }
        }
    );
  }

  Future<List<String>>_inFutureList() async{
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
          children: <Widget>[
            widget.customBuild(context)
          ],
        ),
      ),
      bottomNavigationBar: new CustomBottomAppBar(),
      floatingActionButton: new FloatingActionButton(
        elevation: 4.0,
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          Navigator.push(context,
            new MaterialPageRoute(
              maintainState: false,
                builder: (context)
            => new StartScreen()),
          );
          },
        child: new Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked ,
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
                style: new TextStyle(
                  color: Colors.black87,
                  fontSize: 18.0
                ),),
                new Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: new SizedBox(
                    height: 40.0,
                    child: new RaisedButton(
                        elevation: 4.0,
                        color: Colors.orange,
                        highlightColor: Colors.orangeAccent,
                        child: new Text('Все понятно!',
                          style: new TextStyle(
                              fontSize: 18.0,
                              color: Colors.white
                          ),),
                        onPressed: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                maintainState: false,
                                builder: (context) => new CharacteristicSkills()),
                          );
                        }),
                  )
                )
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
  bool groupValue = false;

void checkSkill()
{
  setState(() {
    groupValue = true;
  });
}
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
                    itemBuilder: (BuildContext context, int index) => new EntryItem(data[index], groupValue),
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
                        new MaterialPageRoute(
                            maintainState: false,
                            builder: (context) => new CharacterText()),
                      );
                  },
                  child: new Text('Прочитать текст',
                      style: new TextStyle(
                          fontSize: 18.0,
                        color: Colors.white
                      )),
                )
              )
            ],
          ),
        ),
      );
  }
}

class EntryItem extends StatefulWidget {
  final bool groupValue;
  final Entry entry;
  const EntryItem(this.entry, this.groupValue);
  @override
  _EntryItemState createState() {
    return new _EntryItemState(entry);
  }
}

class _EntryItemState extends State<EntryItem> {
  Entry entry;
  bool groupValue;
  _EntryItemState(Entry entry){
    this.entry = entry;
    this.groupValue = groupValue;
  }

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty){

      return new Card(
        child: RadioListTile(
          key: new PageStorageKey<Entry>(root),
          groupValue: groupValue,
          title: new Text(
            root.title,
            style: new TextStyle(fontSize: 14.0),
          ),
          value: true,
          onChanged: (bool value) {
            groupValue = true;
            //TODO сделать условие выбора одного чекбокса
            _charactToList(root, value);
          },
        )
        ,
      );


    }
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
  void _charactToList (Entry root, bool value){
    if(value == true){
//      CharacteristicSkillsState().checkSkill();
      character.add(root.title);
    }
/*
    if(!root.isChecked){
      character.remove(root.title);
    }
*/
  }
}

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
          onPressed: (){
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
                            FileManager(filenames)
                                .writeCharacteristic(content);
                            Navigator.pop(context);
                          },
                          child: new Text('Сохранить'))
                    ],
                  );
                }
            );
          },
        child: new Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked ,
    );
  }
  }

class CustomBABPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final List<Widget> rowContent = <Widget> [
      new IconButton(
          icon: const Icon(Icons.home),
          color: Colors.white,
          onPressed: (){
            Navigator.push(context,
            new MaterialPageRoute(
                builder: (context) => new StartPage()
            ));
          }),

      new IconButton(
          icon: const Icon(Icons.mail),
          color: Colors.white,
          onPressed: (){
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
      'subject=Текст характеристики - черновик'
      +'&body='+body;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

//TODO добавить функционал получения разрешений на запись и чтение

class CustomBottomAppBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final List<Widget> rowContent = <Widget> [
      new IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.white,
          onPressed: (){
          }),
    ];
    return new BottomAppBar(
      color: Colors.blue,
      child: new Row(children: rowContent),
    );
  }
}

class BottomAppBarSavePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final List<Widget> rowContent = <Widget> [
      new IconButton(
          icon: const Icon(Icons.home),
          color: Colors.white,
          onPressed: (){
          }),
    ];
    return new BottomAppBar(
      color: Colors.blue,
      child: new Row(children: rowContent),
    );
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.isChecked, this.title, [this.children = const <Entry>[]]);
  final String title;
  List<Entry> children;
  bool isChecked;
}

List<Entry> data = <Entry>[
  new Entry(false,
    '1. Компетентность',
    <Entry>[
      new Entry(false, 'Опыт работы и практические знания',  <Entry>[
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
      new Entry(false,'Интерес к новому опыту', <Entry>[
        new Entry(false,'Постоянно следит за передовым опытом в своей сфере деятельности, стремится его внедрить на своем участке работы и достирает больших успехов в этом отношении.'),
        new Entry(false,'Следит за передовым опытом в своей сфере деятельности и стремится его внедрить на своем участке работы.'),
        new Entry(false,'Проявляет необходимый интерес к передовому опыту.'),
        new Entry(false,'Интерес к передовому опыту проявляется недостаточно.'),
        new Entry(false,'Передовым опытом практически не интересуется.'),
        new Entry(false,'Демонстрирует совершенное равнодушие к передовому опыту.'),
      ]),
      new Entry(false,'Профессиональные знания', <Entry>[
        new Entry(false,'Обладает очень большими профессиональными знаниями в своей области работы, по многим вопросам может дать консультацию.'),
        new Entry(false,'Обладает хорошими профессиональными знаниями в своей области работы.'),
        new Entry(false,'Обладает достаточными профессиональными знаниями в своей области работы.'),
        new Entry(false,'Обладает не вполне достаточными профессиональными знаниями в своей области работы.'),
        new Entry(false,'Не обладает необходимыми профессиональными знаниями в своей области работы.'),
        new Entry(false,'Не имеет сколько-нибудь существенных профессиональных знаний в своей области работы.'),
      ]),
      new Entry(false,'Знание материальной части', <Entry>[
        new Entry(false,'Прекрасно разбирается в материальной части вверенной техники, имеет ясное представление о необходимых технических средствах, обслуживания и ремонта, по многим вопросам может дать консультацию.'),
        new Entry(false,'Хорошо знает материальную часть вверенной техники, имеет представление о необходимых технических средствах ее обслуживания и ремонта.'),
        new Entry(false,'Имеет представление о материальной части вверенной техники, технических средствах обслуживания и ремонта.'),
        new Entry(false,'Знания о материальной части вверенной техники, технических средствах обслуживания и ремонта несколько недостаточны.'),
        new Entry(false,'Не имеет необходимых знаний о материальной части вверенной техники, технических средствах обслуживания и ремонта.'),
        new Entry(false,'Понятия не имеет о материальной части вверенной техники, технических средствах обслуживания и ремонте.'),
      ]),
      new Entry(false,'Знание бухгалтерского учета', <Entry>[
        new Entry(false,'Отлично разбирается в бухгалтерском учете и отчетности.'),
        new Entry(false,'Неплохо разбирается в бухгалтерском учете я отчетности.'),
        new Entry(false,'Имеет необходимое представление о бухгалтерском учете и отчетности.'),
        new Entry(false,'Недостаточно хорошо разбирается в бухгалтерском учете и отчетности.'),
        new Entry(false,'Очень слабо разбирается в бухгалтерском учете и отчетности.'),
        new Entry(false,'В бухгалтерском учете и отчетности абсолютно не разбирается.'),
      ]),
      new Entry(false,'Правовые знания', <Entry>[
        new Entry(false,'Обладает большими правовыми знаниями в своей области работы, хорошо знает не только соответствующее законодательство, но и юридическую практику по решению тех или иных вопросов.'),
        new Entry(false,'Обладает хорошими правовыми знаниями.'),
        new Entry(false,'Имеет необходимый для своей работы минимум правовых знания.'),
        new Entry(false,'Свой багаж правовых знаний не мешало и пополнить.'),
        new Entry(false,'Правовых знаний явно не имеет.'),
        new Entry(false,'Часто демонстрирует правовую безграмотность, даже представление о необходимости правовых знаний при решении тех или иных вопросов отсутствует.'),
      ]),
      new Entry(false,'Знание своих прав, обязанностей и ответственности', <Entry>[
        new Entry(false,'Отлично знает свои права, обязанности и ответственность, знает точно, где и что по этому поводу зафиксировано и умеет, при необходимости, это знание использовать.'),
        new Entry(false,'Знает права, обязанности и ответственность, имеет представление о документах, относящихся к этому вопросу.'),
        new Entry(false,'Имеет представление о своих правах, обязанностях и ответственности.'),
        new Entry(false,'Не очень хорошо знает свои права, обязанности и ответственность.'),
        new Entry(false,'Свои права, обязанности и ответственность представляет себе довольно смутно.'),
        new Entry(false,'О своих правах, обязанностях и ответственности не имеет понятия'),
      ]),
      new Entry(false,'Знание документооборота на своем участке работы', <Entry>[
        new Entry(false,'Прекрасно знает документооборот на своем участке работы, умеет правильно составить и проверить необходимую документацию и предвидеть возможные результаты ее дальнейшего прохождения.'),
        new Entry(false,'Хорошо знает документооборот на своем участке работы, умеет составить и проверить необходимую документацию.'),
        new Entry(false,'Имеет представление о документообороте на своем участке работы.'),
        new Entry(false,'Имеет некоторое представление о документообороте на своем участке работы, но недостаточное.'),
        new Entry(false,'Плохо знает документооборот на своем участке работы, не умеет составлять и проверять необходимую документацию.'),
        new Entry(false,'Совершенно не имеет представление о документообороте на своем участке работы, не может составить или проверить простейшую документацию.'),
      ]),
      new Entry(false,'Умение планировать работу', <Entry>[
        new Entry(false,'Прекрасно умеет планировать работу, достигает очень высокой жизнеспособности и реалистичности плана.'),
        new Entry(false,'Хорошо умеет планировать работу.'),
        new Entry(false,'В целом справляется с планированием работы.'),
        new Entry(false,'С планированием работы справляется не очень хорошо.'),
        new Entry(false,'Плохо справляется с планированием работы.'),
        new Entry(false,'Совершенно не умеет планировать даже самую простую работу, планы оказываются нежизнеспособными с первой же минуты.'),
      ]),
      new Entry(false,'Развитие подчиненных сотрудников', <Entry>[
        new Entry(false,'Всячески способствует повышению квалификации своих подчиненных, используя для этого все имеющиеся возможности.'),
        new Entry(false,'Заботится о повышении квалификации своих подчиненных.'),
        new Entry(false,'Проявляет необходимую заинтересованность в повышении квалификации своих подчиненных.'),
        new Entry(false,'Не проявляет должной заботы о повышении квалификации своих подчиненных.'),
        new Entry(false,'Совершенно не заботятся о повышения квалификации своих подчиненных.'),
        new Entry(false,'Нисколько не заботится о повышении квалификации своих работников, и даже в определенной степени препятствует этому.'),
      ]),
      new Entry(false,'Прогнозирование развития ситуации', <Entry>[
        new Entry(false,'Умеет строить обоснованные долгосрочные прогнозы, обладает отличным чувством перспективы.'),
        new Entry(false,'Умеет предвидеть развитие событий, обладает чувством перспективы.'),
        new Entry(false,'Умеет иногда предвидеть дальнейший ход событий, имеет чувство перспективы.'),
        new Entry(false,'При решении служебных вопросов иногда не хватает чувства перспективы.'),
        new Entry(false,'При решении служебных вопросов не всегда учитывает интерес завтрашнего дня, сказывается недостаток чувства перспективы.'),
        new Entry(false,'Совершенно не умеет предвидеть дальнейший ход событий, не имеет чувства перспективы и живет только сегодняшним днем.'),
      ]),
      new Entry(false,'Использование компьтерной техники', <Entry>[
        new Entry(false,'Имеет значительные знания в области вычислительной техники и оргтехники, постоянно следит за новинками в этой области, по многим вопросам может дать консультацию.'),
        new Entry(false,'Имеет неплохие знания в области вычислительной техники и оргтехники.'),
        new Entry(false,'Имеет представление о средствах вычислительной техники и возможностях их использования.'),
        new Entry(false,'Не имеет достаточных представлений о средствах вычислительной техники и оргтехники, плохо представляет себе возможности их использования.'),
        new Entry(false,'Имеет весьма смутное представление о средствах вычислительной техники и оргтехники и о возможностях их использования.'),
        new Entry(false,'Понятия не имеет ни о средствах вычислительной техники и оргтехники, но и возможностях их использования.'),
      ]),
    ],
  ),
  new Entry(false,
    '2. Работоспособность',
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
    '3. Деловитость',
    <Entry>[
      new Entry(false,'Соблюдение сроков', <Entry>[
        new Entry(false,'Всегда все делает вовремя, всегда укладывается в срок, в связи с этим можно совершенно не беспокоиться.'),
        new Entry(false,'Обычно все делает вовремя и укладывается в срок - можно положиться.'),
        new Entry(false,'В основном порученные задания выполняет в срок и других товарищей не подводит.'),
        new Entry(false,'Не всегда выполняет порученную работу вовремя, иногда не укладывается в срок, но в особо ответственных случаях старается не подводить других товарищей.'),
        new Entry(false,'Часто при выполнении порученных заданий не укладывается в срок и подводит этим других товарищей.'),
        new Entry(false,'Постоянно не укладывается в срок и подводит этим других товарищей, на такого человека совершенно невозможно положиться.'),
      ]),
      new Entry(false,'Способность понимания сути вопроса', <Entry>[
        new Entry(false,'Может мгновенно ухватить суть вопроса, с двух слов понять в чем дело, никогда не путается в мелочах.'),
        new Entry(false,'Может быстро разобраться в сути вопроса и выделить главное.'),
        new Entry(false,'Обычно умеет самостоятельно разобраться в сути вопроса, отделить главное от второстепенного.'),
        new Entry(false,'Обычно долго не может понять суть дела, часто путается в мелочах, требует дополнительных пояснений.'),
        new Entry(false,'Обычно долго не может ухватить суть дела, часто путается в мелочах, требует дополнительных пояснений.'),
        new Entry(false,'Совершенно не умеет отделить главное от второстепенного, постоянно путается в мелочах, простую вещь требуется объяснить по несколько раз.'),
      ]),
      new Entry(false,'Качество работы', <Entry>[
        new Entry(false,'Работает практически всегда без ошибок.'),
        new Entry(false,'Работает, в основном, без ошибок, если и допускает ошибки в работе, то они не отражаются на конечных результатах.'),
        new Entry(false,'Редко допускает в работе ошибки, как правило, лишь незначительные.'),
        new Entry(false,'Допускает в работе ошибки, и иногда это сказывается на конечных результатах.'),
        new Entry(false,'Часто допускает в работе ошибки, в тон числе и довольно грубые.'),
        new Entry(false,'Постоянно допускает в работе грубейшие ошибки.'),
      ]),
      new Entry(false,'Отношение к нововведениям', <Entry>[
        new Entry(false,'Любит различные нововведения и реорганизации. Но не любит работать в нормальном спокойном режиме.'),
        new Entry(false,'Порой излишне увлекается различными новшествами и реорганизациями в ущерб текущей работе.'),
        new Entry(false,'Стремится вовремя поддержать любое начинание.'),
        new Entry(false,'Может поддержать полезное начинание, хотя не особенно любит различные нововведения и реорганизации.'),
        new Entry(false,'Порой проявляет изливший консерватизм, не любит различных нововведений и реорганизаций.'),
        new Entry(false,'Проявляет крайний консерватизм, выступает против всякого нововведения.'),
      ],
      ),
      new Entry(false,'Выполнение сложных заданий', <Entry>[
        new Entry(false,'Может успешно выполнять самые сложные задания, справляется с работой, практически, любой сложности.'),
        new Entry(false,'Справляется с работой достаточно высокой сложности. Хорошо справляется с работой средней сложности, но может иногда решать и более сложные задачи.'),
        new Entry(false,'Хорошо справляется лишь с работой не очень большой сложности.'),
        new Entry(false,'Не справляется со сколько-нибудь сложными заданиями, может выполнять лишь относительно простые задания.'),
        new Entry(false,'Может выполнять лишь самые примитивные задания.'),
      ]),
      new Entry(false,'Выполнение распорядка работы', <Entry>[
        new Entry(false,'В работе никогда не считается с личным временем, всегда работает больше положительного срока.'),
        new Entry(false,'Работает, не считаясь с личным временем, столько, сколько требуют интересы дела.'),
        new Entry(false,'Если того требуют интересы дела, проявляет готовность пожертвовать личным временем.'),
        new Entry(false,'Допускает опоздания на работу и преждевременный уход.'),
        new Entry(false,'Часто допускает опоздания и несвоевременный уход с работы.'),
        new Entry(false,'Систематически нарушает режим работы, не делает правильных выводов из замечаний, чем расхолаживает окружающих.'),
      ]),
      new Entry(false,'Соблюдение режима секретности', <Entry>[
        new Entry(false,'Исключительно добросовестно относится к соблюдению режима секретности. Не допускает отклонений ни для себя, ни для товарищей по работе.'),
        new Entry(false,'Хорошо знает, правильно понимает и выполняет требования режима секретности в своей работе.'),
        new Entry(false,'Знает и выполняет требования режима секретности.'),
        new Entry(false,'Знает и, в основном, выполняет требования режима секретности (или нарушений секретности в работе не отмечалось).'),
        new Entry(false,'Отмечены проявления беспечности в соблюдении режима секретности.'),
        new Entry(false,'Отмечена болтливость. Государственную тайну хранить не умеет.'),
      ]),
    ],
  ),
  new Entry(false,
    '4. Организованность',
    <Entry>[
      new Entry(false,'Проявляет исключительную исполнительность и пунктуальность, степень личной инициативы и организованности очень высока.'),
      new Entry(false,'Проявляет четкость, исполнительность, инициативу в выполнении заданий, умеет самостоятельно организовать свою работу.'),
      new Entry(false,'При выполнении заданий проявляет исполнительность, умеет самостоятельно организовать свою работу.'),
      new Entry(false,' При выполнении заданий проявляет исполнительность, но нуждается в посторонней помощи для организации более эффективной работы.'),
      new Entry(false,'В целом отличается исполнительностью, но нуждается в контроле.'),
      new Entry(false,'В работе проявляет безынициативность, неисполнительность и волокиту.')
    ],
  ),
  new Entry(false, '5. Настойчивость',
    <Entry>[
      new Entry(false,'Настойчивость и упорство', <Entry>[
        new Entry(false,'Действует настойчиво, упорно и цепко, не останавливается, пока не достигнет цели или не разберется в каком-то деле досконально.'),
        new Entry(false,'Действует настойчиво, упорно и цепко, не любит останавливаться, пока не доведет дело до конца или не разберется в каком-либо вопросе.'),
        new Entry(false,'В необходимых случаях проявляет достаточную настойчивость и упорство, чтобы довести дело до конца.'),
        new Entry(false,'Не всегда хватает настойчивости и упорства, чтобы достичь своей цели или разобраться в возникшем вопросе.'),
        new Entry(false,'Обычно не хватает настойчивости и упорства, чтобы довести дело до конца или хорошо разобраться в возникшем вопросе.'),
        new Entry(false,'Даже в важных случаях не может проявлять необходимой настойчивости и упорства, чтобы довести дело до конца, все начинает и ничего не заканчивает.')
      ]),
      new Entry(false,'Изобретательность и находчивость', <Entry>[
        new Entry(false,'Обладает поразительной изобретательностью и находчивостью при достижении цели, умеет найти выход из безвыходного положения.'),
        new Entry(false,'В работе постоянно проявляет изобретательность и находчивость при достижении цели, способность найти выход из трудных положений.'),
        new Entry(false,'Может проявить необходимую изобретательность и находчивость для достижения цели. '),
        new Entry(false,'Не всегда хватает изобретательности и находчивости для достижения цели. '),
        new Entry(false,'Обычно не хватает изобретательности и находчивости, чтобы обойти какое-либо препятствие на пути к цели. '),
        new Entry(false,'Не может проявить хоть в какой-то мере изобретательность и находчивость, чтобы обойти возникшее в работе препятствие.')
      ]),
    ],
  ),
  new Entry(false, '6. Организация личного труда',
      <Entry>[
        new Entry(false,'Использование рабочего времени', <Entry>[
          new Entry(false,'Очень плотно использует свой рабочий день, умеет правильно распределить время и силы на выполнение порученной работы.'),
          new Entry(false,'Умеет ценить и правильно распределить свое рабочее время.'),
          new Entry(false,'В основном правильно распределяет и использует свое рабочее время.'),
          new Entry(false,'Не умеет рационально распределять и использовать свое рабочее время, что приводит к неисполнительности.'),
          new Entry(false,'Недобросовестно относится к исполнению служебных обязанностей, допускает факты бесцельного времяпровождения на работе.')
        ]),
        new Entry(false,'Решительность', <Entry>[
          new Entry(false,'Действует решительно, решения принимает быстро, без промедления.'),
          new Entry(false,'Действует решительно, решения принимает своевременно.'),
          new Entry(false,'Не всегда хватает решительности для принятия своевременных решений.'),
          new Entry(false,'Действует несколько нерешительно, не всегда может своевременно принять необходимое решение.'),
          new Entry(false,'Действует нерешительно, не может своевременно принимать необходимые решения, останавливаться на чем-то определенном.'),
          new Entry(false,'Крайне нерешительный человек, долго колеблется, прежде чем решить самый простой вопрос.')
        ]),
        new Entry(false,'Координация действий рабочих групп', <Entry>[
          new Entry(false,'Прекрасно справляется с вопросами координации действий различных работников или подразделений, умело согласовывает их интересы даже в весьма затруднительных случаях.'),
          new Entry(false,'Хорошо справляется с вопросами координации, умеет находить приемлемые решения при согласовании интересов различных работников или подразделений.'),
          new Entry(false,'Может справляться с вопросами координации действий различных работников или подразделений.'),
          new Entry(false,'Не всегда хорошо справляется с вопросами координации действий различных работников или подразделений.'),
          new Entry(false,'Не справляется с вопросами координации действий различных работников или подразделений.'),
          new Entry(false,'Совершенно не справляется с вопросами координации действий различных работников или подразделений, проявляет абсолютную беспомощность в этом отношении.')
        ]),
        new Entry(false,'Контроль за ходом работ', <Entry>[
          new Entry(false,'Может держать под своим контролем массу дел, держать в поле зрения массу деталей, вовремя реагировать на любое отклонение от плана.'),
          new Entry(false,'Может и умело осуществляет правильный и своевременный контроль за ходом дел.'),
          new Entry(false,'Может держать под своим контролем основные моменты в ходе работы.'),
          new Entry(false,'Не всегда умеет осуществить своевременный контроль за ходом дел, может контролировать лишь отдельные моменты.'),
          new Entry(false,'Не умеет осуществлять контроль за ходом дел.'),
          new Entry(false,'Совершенно не может осуществлять какой-либо контроль за ходом дел.')
        ]),
      ]),
  new Entry(false, '7. Скромность',
      <Entry>[
        new Entry(false,'Использование служебного положения', <Entry>[
          new Entry(false,'В личном поведении совершенно безупречный человек, ни в коем случае не допускающий использования служебного положения в неделовых целях.'),
          new Entry(false,'В личном поведении проявляет скромность, не допускает использования своего положения в личных целях.'),
          new Entry(false,'Проявлений нескромности в использовании своего служебного положения не допускает.'),
          new Entry(false,'Отмечены отдельные проявления личной нескромности в использовании своего служебного положения.'),
          new Entry(false,'Иногда проявляет нескромность в использовании своего служебного положения в личных целях.'),
          new Entry(false,'Неоднократно допускались факты злоупотребления служебным положением в личных целях.')
        ]),
        new Entry(false,'Превышение полномочий', <Entry>[
          new Entry(false,'Постоянно превышает свои полномочия, свои права и власть, как будто они ничем не ограничены.'),
          new Entry(false,'В работе часто превышает свои полномочия, свои права и власть.'),
          new Entry(false,'Отмечены случаи превышения полномочий при исполнении служебных обязанностей, неумеренного использования своих прав и власти.'),
          new Entry(false,'Умело применяет в работе свои полномочия, права и власть, никогда их не превышает.'),
          new Entry(false,'Недостаточно использует свои полномочия, свои права и власть, иногда даже в тех случаях, когда это необходимо делать более решительно.'),
          new Entry(false,'Совершенно не умеет использовать своих полномочий, прав и власти, производя впечатление беспомощности и бесправности.')
        ]),
        new Entry(false,'Поведение в быту', <Entry>[
          new Entry(false,'В моральном отношении совершенно безупречный человек, скромный в быту.'),
          new Entry(false,'В быту ведет себя скромно, отличается моральной устойчивостью.'),
          new Entry(false,'В моральном плане отклонений не отмечается, жалобы на неправильное поведение в быту отсутствуют.'),
          new Entry(false,'Имеются сведения о неправильном поведении в быту, моральной неустойчивости.'),
          new Entry(false,'Имеются серьезные жалобы на моральную неустойчивость, неправильное поведение в быту.'),
          new Entry(false,'Своим аморальным поведением разлагает коллектив.')
        ]),
      ]
  ),
  new Entry(false, '8. Умение сплотить коллектив',
      <Entry>[
        new Entry(false,'Взаимоотношения с людьми', <Entry>[
          new Entry(false,'Быстро умеет налаживать тесные личные контакты с различными людьми, с которыми общается по роду работы, службы.'),
          new Entry(false,'Умеет налаживать хорошие взаимоотношения с людьми, с которыми контактирует по роду работы.'),
          new Entry(false,'В целом правильно налаживает взаимоотношения с людьми, с которыми приходится контактировать по роду работы.'),
          new Entry(false,'Не всегда умеет наладить правильные взаимоотношения с теми людьми, с которыми приходится контактировать по роду работы.'),
          new Entry(false,'Не умеет налаживать взаимоотношения с теми людьми, с которыми приходится сталкиваться по роду работы.'),
          new Entry(false,'Совершенно не умеет правильно строить взаимоотношения с людьми.')
        ]),
        new Entry(false,'Организаторские способности', <Entry>[
          new Entry(false,'Прирожденный организатор, отлично умеет расставить людей и распределить наилучшим образом между ними обязанности, организовать коллектив на выполнение служебных задач.'),
          new Entry(false,'Хороший организатор, умеет расставить людей и распределять обязанности, организовать коллектив на выполнение служебных задач.'),
          new Entry(false,'Обладает достаточными организаторскими способностями, может организовать коллектив на выполнение служебных задач.'),
          new Entry(false,'Не обладает достаточными организаторскими способностями, не всегда умеет организовать коллектив на выполнение служебных задач.'),
          new Entry(false,'Не умелый организатор, не может организовать коллектив на выполнение служебных задач.'),
          new Entry(false,'Плохой организатор, в организационных вопросах демонстрирует полную беспомощность.')
        ]),
        new Entry(false,'Делегирование полномочий', <Entry>[
          new Entry(false,'Постоянно вмешивается в работу своих подчиненных, стремится все делать самостоятельно, все вопросы решает единолично.'),
          new Entry(false,'Иногда без особой необходимости вмешивается в работу своих подчиненных и решает за них различные вопросы.'),
          new Entry(false,'В организации коллективной работы стремится опереться на инициативу и самостоятельность подчиненных.'),
          new Entry(false,'Оказывает подчиненным необходимую помощь в работе, избегая мелочной опеки.'),
          new Entry(false,'Иногда без особой необходимости перепоручает своим подчиненным решение тех вопросов, которые следовало бы решить самостоятельно.'),
          new Entry(false,'Часто перепоручает выполнение своих собственных обязанностей своим подчиненным без всякого на то основания.')
        ]),
        new Entry(false,'Авторитет в коллективе', <Entry>[
          new Entry(false,'Пользуется исключительно большим и заслуженным авторитетом в коллективе, уважением всех работников.'),
          new Entry(false,'Имеет большой авторитет в коллективе.'),
          new Entry(false,'Имеет определенный авторитет в коллективе.'),
          new Entry(false,'Имеет некоторый авторитет в коллективе, но не у всех.'),
          new Entry(false,'Не пользуется в коллективе достаточным авторитетом и уважением.'),
          new Entry(false,'Совершенно не пользуется авторитетом и уважением в коллективе.')
        ]),
      ]
  ),
  new Entry(false, '9. Умение устанавливать деловые отношения',
      <Entry>[
        new Entry(false,'Налаживание и поддержание деловых отношений', <Entry>[
          new Entry(false,'Умеет налаживать и поддерживать хорошие деловые отношения с руководителями подразделений, предприятий и организаций на самых различных уровнях, обладает широкими деловыми связями.'),
          new Entry(false,'Может налаживать и поддерживать неплохие деловые отношения с руководителями различных организаций.'),
          new Entry(false,'В целом справляется с задачей налаживания и поддерживания необходимых деловых отношений с руководителями смежных подразделений и организаций.'),
          new Entry(false,'Не всегда умеет наладить или поддержать правильные деловые отношения с руководителями смежных служб и организаций.'),
          new Entry(false,'Не всегда справляется с задачей налаживания и поддерживания правильных деловых отношений с руководителями смежных организаций и служб.'),
          new Entry(false,'Совершенно не умеет налаживать или поддерживать правильные деловые отношения с руководителями смежных организаций и служб.')
        ]),
        new Entry(false,'Умение расположить к себе', <Entry>[
          new Entry(false,'Прекрасно умеет располагать людей к себе, находить с ними общий язык и вызывать их на откровенность.'),
          new Entry(false,'Умеет располагать к себе и находить с ними общий язык.'),
          new Entry(false,'Обычно умеет расположить людей и найти с ними общий язык.'),
          new Entry(false,'Не умеет располагать людей к себе и находить с ними общий язык, не умеет работать с людьми.'),
          new Entry(false,'Постоянно восстанавливает против себя людей, не в состоянии находить с ними общий язык, проявляет полную неспособность работать с людьми.')
        ]),
        new Entry(false,'Поведение в конфликтах', <Entry>[
          new Entry(false,'Умеет избегать конфликтов с людьми даже в таких ситуациях, когда это кажется совершенно невозможным, умеет приводить других к взаимопониманию иди компромиссу, устранять или сглаживать конфликты в коллективе.'),
          new Entry(false,'Своим поведением никогда не создает ссору или нездоровую атмосферу в коллективе, умеет сглаживать конфликты и приводить людей к согласию.'),
          new Entry(false,'Не всегда умеет избежать конфликтов с людьми, но своим поведением не дает повода к ссорам в коллективе.'),
          new Entry(false,'Не умеет сглаживать конфликты и разногласия в коллективе, иногда своим поведением дает повод к ссорам и разногласиям.'),
          new Entry(false,'Своим поведением часто служит причиной ссор, разногласий и нездоровой атмосферы в коллективе.'),
          new Entry(false,'Любит ссоры и интриги, не успокоится, пока не перессорит весь коллектив.')
        ]),
      ]
  ),
  new Entry(false, '10. Умение мобилизовать коллектив на решение задач',
      <Entry>[
        new Entry(false,'Энергия и энтузиазм', <Entry>[
          new Entry(false,'Обладает неисчерпаемой энергией и энтузиазмом, способностью воодушевить других и повести за собой.'),
          new Entry(false,'Своей энергией и энтузиазмом умеет заразить других.'),
          new Entry(false,'Иногда проявляет энергию и энтузиазм.'),
          new Entry(false,'Иногда не достает энергии и энтузиазма.'),
          new Entry(false,'Энергия и энтузиазм совершенно отсутствуют.'),
          new Entry(false,'Своей пассивностью, своим пессимизмом и скептицизмом может испортить хорошее дело.')
        ]),
        new Entry(false,'Стимулирование подчиненных', <Entry>[
          new Entry(false,'Умело использует имеющиеся возможности по стимулированию деятельности подчиненных в нужном направлении и всегда добивается необходимых результатов.'),
          new Entry(false,'Умеет использовать имеющиеся возможности по стимулированию деятельности подчиненных в нужном направлении путем поощрений и наказаний.'),
          new Entry(false,'В целом умеет пользоваться имеющимися возможностями для стимулирования деятельности подчиненных.'),
          new Entry(false,'Не всегда умеет пользоваться имеющимися возможностями для стимулирования деятельности подчиненных.'),
          new Entry(false,'Не умеет успешно использовать доступные возможности для стимулирования деятельности подчиненных.'),
          new Entry(false,'Не умеет разумно использовать имеющиеся возможности для поощрения и наказания подчиненных.')
        ]),
      ]
  ),
  new Entry(false, '11. Объективность в оценке действий и поступков подчиненных',
      <Entry>[
        new Entry(false,'Объективность оценок', <Entry>[
          new Entry(false,'Очень объективно оценивает других работников и результаты их работы, никогда не руководствуясь при этом своим настроением, своими симпатиями и антипатиями.'),
          new Entry(false,'Объективно оценивает других работников и результаты их работы.'),
          new Entry(false,'В целом объективно оценивает других работников и результаты их работы.'),
          new Entry(false,'Не всегда объективно оценивает других работников и результаты их работы.'),
          new Entry(false,'Довольно субъективно оценивает других работников и результаты их работы, в зависимости от их симпатий и антипатий.'),
          new Entry(false,'Крайне субъективно оценивает других работников и результаты их работы, всецело руководствуясь при этом своими симпатиями и антипатиями, своим настроением.')
        ]),
        new Entry(false,'Баланс критики и самокритики', <Entry>[
          new Entry(false,'Острокритическое отношение к чужим недостаткам подкреплено самокритичной оценкой собственной деятельности.'),
          new Entry(false,'Правильно понимает значение критики и самокритики. Самокритичность преобладает над критическим отношением к чужим недостаткам.'),
          new Entry(false,'Критическое отношение к чужим недостаткам преобладает над самокритичностью.'),
          new Entry(false,'Отмечена склонность избегать критики и самокритики. Отмечена склонность к необоснованной критике чужих недостатков.')
        ]),
        new Entry(false,'Требовательность', <Entry>[
          new Entry(false,'Проявляет чрезмерную требовательность к другим, требовательность до мелочей, до постоянных придирок - работать в такой обстановке крайне тяжело и неприятно.'),
          new Entry(false,'Слишком большая требовательность, иногда вплоть до придирок, усложняет взаимоотношения с подчиненными.'),
          new Entry(false,'Проявляет высокую, но, как правило, обоснованную требовательность к другим.'),
          new Entry(false,'В работе проявляет достаточную требовательность без мелочных придирок.'),
          new Entry(false,'В работе не проявляет необходимой требовательности к другим, часто "закрывает глаза" на чужие недостатки.'),
          new Entry(false,'Совершенно отсутствует требовательность, способность призывать к порядку даже в самых необходимых случаях.')
        ]),
      ]
  ),
  new Entry(false, '12. Принципиальность',
      <Entry>[
        new Entry(false,'Собственное мнение', <Entry>[
          new Entry(false,'Стремится по любым вопросам высказывать собственное мнение, даже по таким, в которых абсолютно не разбирается.'),
          new Entry(false,'Часто высказывает собственное мнение даже по таким вопросам, в которых не очень хорошо разбирается.'),
          new Entry(false,'Не боится высказать собственное мнение, иногда даже в тех случаях, когда оно противоречит мнению большинства.'),
          new Entry(false,'Редко высказывает собственное мнение даже в тех случаях, когда его и имеет.'),
          new Entry(false,'Обычно избегает высказывать собственное мнение даже по непринципиальным вопросам.'),
          new Entry(false,'Даже в пустяковых вопросах не имеет собственного мнения.')
        ]),
        new Entry(false,'Упрямство', <Entry>[
          new Entry(false,'Проявляет упрямство, не изменяет своей точки зрения даже тогда, когда очевидна ее абсурдность.'),
          new Entry(false,'Неохотно меняет мнение даже в тех случаях, когда оно явно неверно.'),
          new Entry(false,'Неохотно меняет свое мнение, но убедившись в его ошибочности, все-таки изменяет.'),
          new Entry(false,'Хотя обычно свое мнение без особых причин не меняет, но под чужим нажимом может изменить.'),
          new Entry(false,'Легко меняет свое мнение под посторонним нажимом.'),
          new Entry(false,'Крайне легко меняет свое мнение, достаточно самого небольшого нажима извне.')
        ]),
      ]
  ),
  new Entry(false, '13. Чувство ответственности за порученное дело',
      <Entry>[
        new Entry(false,'Служебная дисциплина', <Entry>[
          new Entry(false,'Исключительно добросовестно относится к требованиям служебной дисциплины. Проявляет способность противостоять разлагающему влиянию извне.'),
          new Entry(false,'Требования служебной дисциплины понимает правильно и полностью выполняет.'),
          new Entry(false,'Нареканий за нарушение дисциплины не имеет.'),
          new Entry(false,'Дисциплинарных взысканий не имеет.'),
          new Entry(false,'Имелись грубые нарушения дисциплины, однако, под воспитательным воздействием сделаны правильные выводы и предприняты шаги к исправлению поведения.'),
          new Entry(false,'Неоднократно допускались грубые нарушения служебной дисциплины, правильных выводов до сих пор не сделано.')
        ]),
        new Entry(false,'Ответственность за свои поступки', <Entry>[
          new Entry(false,'Не боится за свои поступки: скорее примет вину на себя, чем подведет товарища.'),
          new Entry(false,'Обычно отвечает за свои поступки, всегда признает свою вину, если виноват.'),
          new Entry(false,'Умеет отвечать за свои поступки, при необходимости признает свою вину.'),
          new Entry(false,'Неохотно признает свою вину, даже если она действительно имеет место.'),
          new Entry(false,'Обычно не признает свою вину, даже если она действительно имеет место. Старается переложить ответственность на других.'),
          new Entry(false,'Никогда не признает своей вины, какой бы они ни была и всеми способами перекладывает ответственность на других людей.')
        ]),
        new Entry(false,'Выполнение обещаний', <Entry>[
          new Entry(false,'Свои обещания выполняет, других людей не подводит, умеет держать данное слово.'),
          new Entry(false,'Обычно свои обещания выполняет и других не подводит. '),
          new Entry(false,'Всегда старается выполнить свои обещания, не нарушать данного слова, чтобы не подводить других.'),
          new Entry(false,'Не всегда выполняет свои обещания и иногда подводит этим других.'),
          new Entry(false,'Очень часто не выполняет своих обещаний и подводит этим других.'),
          new Entry(false,'Постоянно не выполняет своих обещаний и даже не стремится этого делать.')
        ]),
      ]
  ),
  new Entry(false, '14. Черты характера',
      <Entry>[
        new Entry(false,'Уравновешенность', <Entry>[
          new Entry(false,'По характеру очень спокойный, уравновешенный человек, которого невозможно вывести из себя.'),
          new Entry(false,'По характеру спокойный, уравновешенный человек.'),
          new Entry(false,'По характеру спокойный человек, редко проявляет раздражительность и несдержанность.'),
          new Entry(false,'Иногда проявляет излишнюю раздражительность и несдержанность.'),
          new Entry(false,'Излишне легко раздражается и выходит из себя.'),
          new Entry(false,'Крайне раздражительный, несдержанный человек, которого любой пустяк выводит из себя.')
        ]),
        new Entry(false,'Вежливость и тактичность', <Entry>[
          new Entry(false,'В общении с гражданами, товарищами по работе постоянно проявляется доброжелательность, чуткость и такт.'),
          new Entry(false,'В общении с гражданами и товарищами по работе постоянно проявляет вежливость, умеет внимательно выслушивать собеседника.'),
          new Entry(false,'В общении с гражданами, товарищами по работе проявляет вежливость и такт.'),
          new Entry(false,'В общении с гражданами, товарищами по работе, в основном, ведет себя правильно.'),
          new Entry(false,'В общении с гражданами, товарищами по работе, в основном ведет себя правильно, однако, излишняя категоричность суждений нередко переходит в бестактность или грубость.'),
          new Entry(false,'В общении с гражданами, товарищами по работе проявляет элементы грубости и высокомерия.')
        ]),
        new Entry(false,'Взаимопомощь', <Entry>[
          new Entry(false,'Очень охотно оказывает помощь товарищам по работе, никогда не жалеет для этого своего времени и сил.'),
          new Entry(false,'Охотно оказывает помощь товарищам по работе. Оказывает помощь товарищам по работе, хотя и не всегда охотно.'),
          new Entry(false,'Не любит оказывать помощь товарищам по работе, по возможности избегает таких ситуаций.'),
          new Entry(false,'Никогда не оказывает помощи товарищам по работе, скорее может им препятствовать.')
        ]),
        new Entry(false,'Самообладание', <Entry>[
          new Entry(false,'В любой ситуации сохраняет исключительное хладнокровие и способность к быстрому принятию верных решений.'),
          new Entry(false,'В сложных ситуациях проявляет хладнокровие и решительность.'),
          new Entry(false,'В сложных ситуациях личная активность не снижается, однако не всегда выбирает верные решения.'),
          new Entry(false,'В сложных ситуациях проявляет склонность неоправданно горячиться, нуждается в контроле.'),
          new Entry(false,'В сложных ситуациях снижается личная активность и проявляется стремление действовать под чужим руководством.'),
          new Entry(false,'В сложной ситуации проявляет пассивность и нуждается в постоянном понукании.')
        ]),
        new Entry(false,'Оценка своих возможностей', <Entry>[
          new Entry(false,'Правильно оценивает свои возможности и не боится попробовать себя на более широком поле деятельности.'),
          new Entry(false,'Переоценка своих возможностей нередко приводит к ошибкам в работе.'),
          new Entry(false,'Недооценка своих возможностей сужает поле деятельности.'),
          new Entry(false,'Явно переоценивает свои возможности, это бросается в глаза веем окружающим и отрицательно сказывается на результатах работы.'),
          new Entry(false,'Явно недооценивает свои возможности и это бросается в глаза всем окружающим.')
        ]),
        new Entry(false,'Отношение к критике', <Entry>[
          new Entry(false,'Критику в свой адрес воспринимает правильно, немедленно принимает меры к устранению недостатков.'),
          new Entry(false,'На критические замечания реагирует правильно.'),
          new Entry(false,'Болезненно реагирует на критику, однако, делает из нее правильные выводы.'),
          new Entry(false,'Правильно понимает товарищескую критику, но проявляет склонность оспаривать критику со стороны подчиненных и начальников.'),
          new Entry(false,'Реагирует только на критику "сверху".'),
          new Entry(false,'Не умеет делать правильных выводов из критических замечаний.')
        ]),
        new Entry(false,'Отношение к алкоголю', <Entry>[
          new Entry(false,'Убежденный противник употребления алкоголя. Проявляет способность противостоять в этом вопросе мнению большинства.'),
          new Entry(false,'Ведет трезвый образ жизни. Может противостоять в этом вопросе мнению большинства.'),
          new Entry(false,'Случаев злоупотребления алкоголем не отмечалось.'),
          new Entry(false,'После взыскания за употребление алкоголем были сделаны правильные выводы и исправлено поведение.'),
          new Entry(false,'Имеет взыскание за злоупотребление алкоголем, однако вины за собой не чувствует.'),
          new Entry(false,'Несмотря на взыскание за употребление спиртным должных выводов пока не сделано.')
        ]),
      ]
  ),
  new Entry(false, '15. Физическая закалка',
      <Entry>[
        new Entry(false,'Уровень физического развития', <Entry>[
          new Entry(false,'Физическое развитие отличное, постоянно поддерживает высокую спортивную форму.'),
          new Entry(false,'Физическое развитие хорошее, постоянно поддерживает спортивную форму.'),
          new Entry(false,'Физическое развитие хорошее.'),
          new Entry(false,'Физическое развитие нормальное.'),
          new Entry(false,'Физическое развитие нормальное, однако, к поддержанию спортивной формы относится беспечно.'),
          new Entry(false,'Физическое развитие и отношение к поддержанию спортивной формы неудовлетворительное.')
        ]),
        new Entry(false,'Занятия спортом', <Entry>[
          new Entry(false,'С увлечением занимается спортом. Привлекает к этому своих коллег и подчиненных.'),
          new Entry(false,'Активно занимается спортом, подает хороший пример своим коллегам и подчиненным.'),
          new Entry(false,'Постоянно занимается спортом, подает хороший пример своим коллегам и подчиненным.'),
          new Entry(false,'Регулярно занимается спортом.'),
          new Entry(false,'Спортом занимается несистематически.'),
          new Entry(false,'Спортом не увлекается.')
        ]),
      ]
  ),
];
