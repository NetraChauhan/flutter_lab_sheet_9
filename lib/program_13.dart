import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_ui.dart';

void main()=>runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  theme:apiTheme(const Color(0xFF0F766E)),
  home:const App(),
));

class App extends StatefulWidget{
  const App({super.key});
  State<App> createState()=>S();
}

class S extends State<App>{
  List posts=[];
  String status='Pull down to reload';

  void initState(){super.initState();load();}

  Future<void> load()async{
    final r=await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=12'));
    posts=jsonDecode(r.body);
    status='Updated just now';
    if(mounted)setState((){});
  }

  @override
  Widget build(BuildContext context)=>ApiPage(
    title:'Pull to Refresh',
    subtitle:'RefreshIndicator reloads API data',
    color:const Color(0xFF0F766E),
    icon:Icons.refresh_rounded,
    child:Column(children:[
      infoBox(status,const Color(0xFF0F766E)),
      const SizedBox(height:12),
      SizedBox(
        height:420,
        child:RefreshIndicator(
          onRefresh:load,
          child:ListView.builder(
            physics:const AlwaysScrollableScrollPhysics(),
            itemCount:posts.isEmpty?1:posts.length,
            itemBuilder:(context,i){
              if(posts.isEmpty){
                return const SizedBox(
                  height:300,
                  child:Center(child:CircularProgressIndicator()),
                );
              }
              return Card(
                child:ListTile(
                  leading:CircleAvatar(child:Text((i+1).toString())),
                  title:Text(posts[i]['title'].toString()),
                ),
              );
            },
          ),
        ),
      ),
    ]),
  );
}
