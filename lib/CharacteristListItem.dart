import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app2/CharacteristicPage.dart';
import 'package:flutter_app2/main.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CharacteristListItem extends StatelessWidget {
  var characteristic = new List<String>();

  final String charactTitle;

  CharacteristListItem(String charactTitle)
      : charactTitle = charactTitle;

  @override
  Widget build(BuildContext context) {
    var charactPath =
        '/data/data/ru.characterist.flutterapp2/app_flutter/user_data/'
            + charactTitle;

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: new Card(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              flex: 1,
              child: new Icon(
                Icons.account_circle,
                color: Colors.blue,
                size: 44.0,),
            ),
            new Expanded(
              flex: 5,
              child: new Column(
                children: <Widget>[
                  new Text(charactTitle,
                    style: new TextStyle(
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  //TODO после удаления файла получаем здесь исключение
                  new FutureBuilder(
                      future: getData(charactPath),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return new Text('Data is loading...');
                        }
                        else {
                          var format = new DateFormat.yMd();
                          DateTime fileDate = snapshot.data;
                          var dateString = format.format(fileDate);
                          return new Text(dateString);
                        }
                      }
                  ),
                  new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new FlatButton(onPressed: () {
                        //TODO сделать переход на экран с техтом характеристики
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              maintainState: false,
                              builder: (context) =>
                              new CharacteristicPage(charactPath)),
                        );
                      },
                        child: new Text('Читать',
                          style: new TextStyle(
                              fontSize: 16.0,
                              color: Colors.teal
                          ),
                        ),
                      ),
                      new IconButton(
                          icon: new Icon(
                            Icons.mail,
                            color: Colors.teal,
                          ),
                          onPressed: () async {
                            _launchURL();
                          }
                      ),
                      new IconButton(
                          icon: new Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deleteCharacteristic(charactPath);
                            Navigator.push(context,
                              new MaterialPageRoute(
                                  builder: (context) => new CharacteristList()),
                            );
                          }
                      )
                    ],
                  )
                ],
              ),

            )
          ],
        ),
      ),
    );
  }

  Future<File> deleteCharacteristic(String filepath) async {
    final file = new File(filepath);
    return file.delete(recursive: true);
  }

  Future<DateTime> getData(String filepath) async {
    final file = new File(filepath);
    return file.lastModified();
  }

  _launchURL() async {
    var charactPath2 =
        '/data/data/ru.characterist.flutterapp2/app_flutter/user_data/'
            + charactTitle;

    List<String> content = await readCharacteristic(charactPath2);
    String body = content.join("\n");

    var url = 'mailto:?'
        'subject=Текст характеристики '+charactTitle
    +'&body='+body;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<List<String>> readCharacteristic(String filepath) async{
    final file = new File(filepath);
    characteristic = await file.readAsLines();
    return characteristic;
  }


}
