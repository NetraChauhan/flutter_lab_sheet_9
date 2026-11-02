import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_ui.dart';

void main()=>runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  theme:apiTheme(const Color(0xFF7C3AED)),
  home:const App(),
));

class App extends StatefulWidget{
  const App({super.key});
  State<App> createState()=>S();
}

class S extends State<App>{
  Map<String,dynamic>? post;

  void initState(){super.initState();fetch();}

  Future<void> fetch()async{
    final r=await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
    post=jsonDecode(r.body);
    if(mounted)setState((){});
  }

  @override
  Widget build(BuildContext context)=>ApiPage(
    title:'Single Post',
    subtitle:'Title + body displayed in a Card',
    color:const Color(0xFF7C3AED),
    icon:Icons.article_rounded,
    child:post==null
      ?const Center(child:CircularProgressIndicator())
      :Card(
        child:Padding(
          padding:const EdgeInsets.all(20),
          child:Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children:[
              Text(post!['title'].toString(),
                style:const TextStyle(fontSize:22,fontWeight:FontWeight.w800)),
              const SizedBox(height:10),
              Text(post!['body'].toString(),
                style:const TextStyle(fontSize:16,height:1.5)),
            ],
          ),
        ),
      ),
  );
}
