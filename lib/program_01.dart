import 'dart:convert';
import 'package:flutter/material.dart';
import 'api_ui.dart';

void main()=>runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  theme:apiTheme(const Color(0xFF4F46E5)),
  home:const App(),
));

class Student{
  final int id;
  final String name,course;
  Student({required this.id,required this.name,required this.course});

  factory Student.fromJson(Map<String,dynamic> j)=>
    Student(id:j['id'],name:j['name'],course:j['course']);
}

class App extends StatelessWidget{
  const App({super.key});

  @override
  Widget build(BuildContext context){
    const jsonText='''[
      {"id":1,"name":"Aarav Mehta","course":"BCA"},
      {"id":2,"name":"Mira Kapoor","course":"BBA"},
      {"id":3,"name":"Kabir Shah","course":"BCA"}
    ]''';

    final List data=jsonDecode(jsonText);
    final students=data.map((e)=>Student.fromJson(e)).toList();

    return ApiPage(
      title:'JSON Students',
      subtitle:'JSON array → List<Student> using fromJson()',
      color:const Color(0xFF4F46E5),
      icon:Icons.data_object_rounded,
      child:Column(children:[
        infoBox(students.length.toString()+' Student objects created',const Color(0xFF4F46E5)),
        const SizedBox(height:14),
        ...students.map((s)=>Card(child:ListTile(
          leading:CircleAvatar(child:Text(s.id.toString())),
          title:Text(s.name),
          subtitle:Text('Course: '+s.course),
        )))
      ]),
    );
  }
}
