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
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Характеристика'),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(14.0),
        child: new Column(
          children: <Widget>[
            new FutureBuilder(
                future: readCharacteristic(charactPath),
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
      bottomNavigationBar: new CustomBABPage(),
    );

  }

  Widget customBuild(BuildContext context, AsyncSnapshot snapshot){
    List<String> values = snapshot.data;
    return new Container(
        child: new Expanded(
          child: new ListView.builder(
            itemCount: values.length,
            itemBuilder: (context, index){
              return new ListTile(
                title: new Text(values[index]),
              );
            },
          ),
        )
    );
  }

  Future<List<String>> readCharacteristic(String filepath) async{
    var characteristic = new List<String>();
    final file = new File(filepath);
    characteristic = await file.readAsLines();
    return characteristic;
  }
}

class CustomBABPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final List<Widget> rowContent = <Widget> [
      new IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: (){
            Navigator.pop(context);
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
