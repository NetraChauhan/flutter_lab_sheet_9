import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_ui.dart';

void main()=>runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  theme:apiTheme(const Color(0xFFEA580C)),
  home:const App(),
));

class App extends StatefulWidget{
  const App({super.key});
  State<App> createState()=>S();
}

class S extends State<App>{
  bool loading=false;
  String result='No data loaded yet';

  Future<void> fetch()async{
    setState(()=>loading=true);
    final r=await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/2'));
    final data=jsonDecode(r.body);
    setState((){
      result=data['title'];
      loading=false;
    });
  }

  @override
  Widget build(BuildContext context)=>ApiPage(
    title:'API Loading State',
    subtitle:'CircularProgressIndicator while fetching',
    color:const Color(0xFFEA580C),
    icon:Icons.sync_rounded,
    centered:true,
    child:Column(children:[
      if(loading)
        const Padding(
          padding:EdgeInsets.all(28),
          child:CircularProgressIndicator(),
        )
      else
        Padding(
          padding:const EdgeInsets.symmetric(vertical:18),
          child:Text(result,
            textAlign:TextAlign.center,
            style:const TextStyle(fontSize:20,fontWeight:FontWeight.w700)),
        ),
      FilledButton(onPressed:loading?null:fetch,child:const Text('Fetch Data'))
    ]),
  );
}
