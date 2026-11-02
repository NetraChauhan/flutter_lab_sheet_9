import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_ui.dart';

void main()=>runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  theme:apiTheme(const Color(0xFF9333EA)),
  home:const App(),
));

class App extends StatefulWidget{
  const App({super.key});
  State<App> createState()=>S();
}

class S extends State<App>{
  List users=[];

  void initState(){super.initState();fetch();}

  Future<void> fetch()async{
    final r=await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'));
    users=jsonDecode(r.body);
    if(mounted)setState((){});
  }

  @override
  Widget build(BuildContext context)=>ApiPage(
    title:'API Users',
    subtitle:'Name + email using ListTile and CircleAvatar',
    color:const Color(0xFF9333EA),
    icon:Icons.groups_rounded,
    child:SizedBox(
      height:440,
      child:users.isEmpty
        ?const Center(child:CircularProgressIndicator())
        :ListView.builder(
          itemCount:users.length,
          itemBuilder:(context,i){
            final u=users[i];
            return Card(
              child:ListTile(
                leading:CircleAvatar(
                  child:Text(u['name'].toString().substring(0,1)),
                ),
                title:Text(u['name'].toString()),
                subtitle:Text(u['email'].toString()),
              ),
            );
          },
        ),
    ),
  );
}
