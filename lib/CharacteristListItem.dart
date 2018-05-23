import 'package:flutter/material.dart';

// TODO добавить корзину для возможности удаления

class CharacteristListItem extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: new Card(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(Icons.account_circle,
            color: Colors.blue,
            size: 44.0,),
            new Column(
                children: <Widget>[
                  new Text('Сharacteristic',
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
                    children: <Widget>[
                      new FlatButton(onPressed: null,
                          child: new Text('Изменить',
                            style: new TextStyle(
                                fontSize: 16.0,
                                color: Colors.teal
                            ),)),
                      new FlatButton(onPressed: null,
                          child: new Text('Читать',
                          style: new TextStyle(
                            fontSize: 16.0,
                            color: Colors.teal
                          ),)),
                      new Icon(Icons.share,
                      color: Colors.teal,)
                    ],
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }

}