import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_ui.dart';

void main()=>runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  theme:apiTheme(const Color(0xFF0F766E)),
  home:const App(),
));

class User{
  final int id;
  final String name,email;

  User({required this.id,required this.name,required this.email});

  factory User.fromJson(Map<String,dynamic> j)=>
    User(id:j['id'],name:j['name'],email:j['email']);
}

class App extends StatefulWidget{
  const App({super.key});
  State<App> createState()=>S();
}

class S extends State<App>{
  List<User> users=[];

  void initState(){super.initState();fetch();}

  Future<void> fetch()async{
    final r=await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'));
    final List data=jsonDecode(r.body);
    users=data.map((j)=>User.fromJson(j)).toList();
    if(mounted)setState((){});
  }

  @override
  Widget build(BuildContext context)=>ApiPage(
    title:'User Model Objects',
    subtitle:'API JSON → User.fromJson() → objects',
    color:const Color(0xFF0F766E),
    icon:Icons.account_box_rounded,
    child:Column(children:[
      infoBox(
        users.length.toString()+' API records converted to User objects',
        const Color(0xFF0F766E),
      ),
      const SizedBox(height:12),
      ...users.take(5).map((u)=>Card(
        child:ListTile(
          leading:CircleAvatar(child:Text(u.id.toString())),
          title:Text(u.name),
          subtitle:Text(u.email),
        ),
      )),
    ]),
  );
}
