import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_ui.dart';

void main()=>runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  theme:apiTheme(const Color(0xFFD97706)),
  home:const App(),
));

class App extends StatefulWidget{
  const App({super.key});
  State<App> createState()=>S();
}

class S extends State<App>{
  final title=TextEditingController();
  final body=TextEditingController();
  String message='';

  Future<void> send()async{
    setState(()=>message='Sending...');
    final r=await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers:{'Content-Type':'application/json'},
      body:jsonEncode({
        'title':title.text,
        'body':body.text,
        'userId':1,
      }),
    );

    if(r.statusCode==201){
      final data=jsonDecode(r.body);
      setState(()=>message='Post created successfully! ID: '+data['id'].toString());
    }else{
      setState(()=>message='Failed: HTTP '+r.statusCode.toString());
    }
  }

  @override
  Widget build(BuildContext context)=>ApiPage(
    title:'Create Post',
    subtitle:'Send form data using http.post()',
    color:const Color(0xFFD97706),
    icon:Icons.send_rounded,
    child:Column(children:[
      TextField(
        controller:title,
        decoration:const InputDecoration(labelText:'Title'),
      ),
      const SizedBox(height:12),
      TextField(
        controller:body,
        maxLines:4,
        decoration:const InputDecoration(labelText:'Body'),
      ),
      const SizedBox(height:14),
      SizedBox(
        width:double.infinity,
        child:FilledButton.icon(
          onPressed:send,
          icon:const Icon(Icons.send),
          label:const Text('Send to API'),
        ),
      ),
      if(message.isNotEmpty)...[
        const SizedBox(height:14),
        infoBox(message,const Color(0xFFD97706)),
      ],
    ]),
  );
}
