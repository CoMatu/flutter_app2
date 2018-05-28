import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app2/main.dart';

// TODO добавить корзину для возможности удаления

class CharacteristListItem extends StatelessWidget{

  final String charactTitle;

  CharacteristListItem(String charactTitle)
  : charactTitle = charactTitle;

  @override
  Widget build(BuildContext context) {
    var charactPath =
        '/data/data/ru.characterist.flutterapp2/app_flutter/user_data/'
            +charactTitle;

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
                    new Text('data.month.year',
                      style: new TextStyle(
                          color: Colors.black54
                      ),
                      textAlign: TextAlign.start,
                    ),
                    new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new FlatButton(onPressed: (){
                          //TODO сделать переход на экран с техтом характеристики
                        },
                          child: new Text('Читать',
                            style: new TextStyle(
                                fontSize: 16.0,
                                color: Colors.teal
                            ),
                          ),
                        ),
                        new FlatButton(
                            onPressed: (){

                            },
                            child: new Text('Поделиться',
                            style: new TextStyle(
                              fontSize: 16.0,
                                color: Colors.teal
                            ),
                            )
                        ),
                         new IconButton(
                             icon: new Icon(
                                 Icons.delete,
                               color: Colors.red,
                             ),
                             onPressed: (){
                               deleteCharacteristic(charactPath);
                               Navigator.push(context,
                                 new MaterialPageRoute(builder: (context)
                                 => new CharacteristList()),
                               );

                             }
                             )
/*
                        new Icon(Icons.share,
                          color: Colors.teal,),
*/
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
  Future<File> deleteCharacteristic(String filepath) async{
    final file = new File(filepath);
    return file.delete(recursive: true);
  }

}