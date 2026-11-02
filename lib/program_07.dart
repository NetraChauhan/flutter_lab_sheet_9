import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_ui.dart';

void main()=>runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  theme:apiTheme(const Color(0xFF059669)),
  home:const App(),
));

class App extends StatefulWidget{
  const App({super.key});
  State<App> createState()=>S();
}

class S extends State<App>{
  List posts=[];

  void initState(){super.initState();fetch();}

  Future<void> fetch()async{
    final r=await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=10'));
    posts=jsonDecode(r.body);
    if(mounted)setState((){});
  }

  @override
  Widget build(BuildContext context)=>ApiPage(
    title:'Post Titles',
    subtitle:'REST API + ListView.builder',
    color:const Color(0xFF059669),
    icon:Icons.view_list_rounded,
    child:SizedBox(
      height:430,
      child:posts.isEmpty
        ?const Center(child:CircularProgressIndicator())
        :ListView.builder(
          itemCount:posts.length,
          itemBuilder:(context,i)=>Card(
            child:ListTile(
              leading:CircleAvatar(child:Text((i+1).toString())),
              title:Text(posts[i]['title'].toString()),
            ),
          ),
        ),
    ),
  );
}
