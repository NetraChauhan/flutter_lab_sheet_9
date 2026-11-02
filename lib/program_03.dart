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
  String body='Tap Fetch Response';

  Future<void> fetch()async{
    final r=await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
    setState(()=>body=r.body);
  }

  @override
  Widget build(BuildContext context)=>ApiPage(
    title:'REST API Response',
    subtitle:'Fetched using http.get()',
    color:const Color(0xFF0369A1),
    icon:Icons.cloud_download_rounded,
    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      SizedBox(
        width:double.infinity,
        child:FilledButton.icon(
          onPressed:fetch,
          icon:const Icon(Icons.download_rounded),
          label:const Text('Fetch Response'),
        ),
      ),
      const SizedBox(height:14),
      const Text('Response Body',
        style:TextStyle(fontWeight:FontWeight.w800)),
      const SizedBox(height:8),
      Container(
        width:double.infinity,
        padding:const EdgeInsets.all(14),
        decoration:BoxDecoration(
          color:const Color(0xFFF0F9FF),
          borderRadius:BorderRadius.circular(14),
        ),
        child:SelectableText(body,
          style:const TextStyle(fontFamily:'monospace')),
      ),
    ]),
  );
}
