import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_ui.dart';

void main()=>runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  theme:apiTheme(const Color(0xFF0369A1)),
  home:const App(),
));

class App extends StatefulWidget{
  const App({super.key});
  State<App> createState()=>S();
}

class S extends State<App>{
  List all=[],filtered=[];

  void initState(){super.initState();fetch();}

  Future<void> fetch()async{
    final r=await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'));
    all=jsonDecode(r.body);
    filtered=List.from(all);
    if(mounted)setState((){});
  }

  void search(String q){
    filtered=all.where((u)=>
      u['name'].toString().toLowerCase().contains(q.toLowerCase())
    ).toList();
    setState((){});
  }

  @override
  Widget build(BuildContext context)=>ApiPage(
    title:'Search API Data',
    subtitle:'Filter fetched users using TextField',
    color:const Color(0xFF0369A1),
    icon:Icons.search_rounded,
    child:Column(children:[
      TextField(
        onChanged:search,
        decoration:const InputDecoration(
          prefixIcon:Icon(Icons.search),
          hintText:'Search by name...',
        ),
      ),
      const SizedBox(height:14),
      if(all.isEmpty)const CircularProgressIndicator(),
      ...filtered.map((u)=>Card(
        child:ListTile(
          leading:const Icon(Icons.person_outline),
          title:Text(u['name'].toString()),
          subtitle:Text(u['email'].toString()),
        ),
      )),
    ]),
  );
}
