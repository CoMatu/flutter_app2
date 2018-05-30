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
    home: new CharacteristList(),
)
);

class CharacteristList extends StatelessWidget {
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
            new FutureBuilder(
                future: _inFutureList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return new Text('Data is loading...');
                  }
                  else{
                    return customBuild(context, snapshot);
                  }
                }
            )
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

  Widget customBuild(BuildContext context, AsyncSnapshot snapshot){
    List<String> values = snapshot.data;
    return new Container(
        child: new Expanded(
          child: new ListView.builder(
            itemCount: values.length,
            itemBuilder: (context, index){
              return new CharacteristListItem(values[index]);
            },
          ),
        )
    );
  }

  Future<List<String>>_inFutureList() async{
    var filesList = new List<String>();
    filesList = await FilesInDirectory().getFilesFromDir();
    await new Future.delayed(new Duration(milliseconds: 500));
    return filesList;
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
                new Text('На следующей странице в раскрывающемся списке выберите одну или несколько компетенций для оценки. Для выбора нажмите "галочку", для отмены - повторное нажатие.',
                style: new TextStyle(
                  color: Colors.black87,
                  fontSize: 22.0
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
];

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
                builder: (context) => new CharacteristList()
            ));
          }),

      new IconButton(
          icon: const Icon(Icons.mail),
          color: Colors.white,
          onPressed: (){
            _launchURL();
          })

    ];
    // TODO: implement build
    return new BottomAppBar(
      hasNotch: true,
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
/*
      new IconButton(
          icon: const Icon(Icons.save),
          color: Colors.white,
          onPressed: (){
          })
*/
    ];
    // TODO: implement build
    return new BottomAppBar(
      hasNotch: true,
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
    // TODO: implement build
    return new BottomAppBar(
      hasNotch: false,
      color: Colors.blue,
      child: new Row(children: rowContent),

    );
  }

}

