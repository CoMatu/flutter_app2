import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class CharacteristicPage extends StatelessWidget{
  String charactPath;

  CharacteristicPage(String charactPath){
    this.charactPath = charactPath;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Характеристика'),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(14.0),
        child: new Column(
          children: <Widget>[
            new Expanded(
              child:
            ),
          ],
        ),
      ),
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

  Future<List<String>> readCharacteristic(String filepath) async{
    final file = new File(filepath);
    characteristic = await file.readAsLines();
    return characteristic;
  }
}