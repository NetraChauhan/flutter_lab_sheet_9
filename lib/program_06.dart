import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_ui.dart';

void main()=>runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  theme:apiTheme(const Color(0xFF2563EB)),
  home:const App(),
));

Future<Map<String,dynamic>> fetchPost()async{
  final r=await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/posts/3'));
  return jsonDecode(r.body);
}

class App extends StatelessWidget{
  const App({super.key});

  @override
  Widget build(BuildContext context)=>ApiPage(
    title:'FutureBuilder API',
    subtitle:'API data displayed using FutureBuilder',
    color:const Color(0xFF2563EB),
    icon:Icons.auto_awesome_motion_rounded,
    child:FutureBuilder<Map<String,dynamic>>(
      future:fetchPost(),
      builder:(context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Center(
            child:Padding(
              padding:EdgeInsets.all(30),
              child:CircularProgressIndicator(),
            ),
          );
        }
        if(snapshot.hasError){
          return const Text('Unable to load data');
        }
        final p=snapshot.data!;
        return Card(child:ListTile(
          leading:const CircleAvatar(child:Icon(Icons.article_outlined)),
          title:Text(p['title'].toString()),
          subtitle:Text(p['body'].toString()),
        ));
      },
    ),
  );
}
