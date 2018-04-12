import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    title: 'Характеристика',
    home: new SkillList(),
  )
  );
}



class SkillList extends StatefulWidget{
  @override
  _SkillState createState() => new _SkillState();
}

class _SkillState extends State<SkillList>{
List items;

@override
void initState(){
  items=  new List.generate(20, (i)=>
  {'title':'title$i','isChecked':false}
  );
  super.initState();
}
  @override
  Widget build(BuildContext context) {
  return new Scaffold(
    body: new ListView(
      children: new List.generate(20, (i){
        return new ListTile(
         title: new Text(items[i]['title']),
          trailing: new Checkbox(
            value: items[i]['isChecked'],
              onChanged: (bool newValue){
                setState(() {
                  this.items[i]['isChecked'] = newValue;
                });
              }),
        );
      }),
    ),  );
  }

}