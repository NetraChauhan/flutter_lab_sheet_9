import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_ui.dart';

void main()=>runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  theme:apiTheme(const Color(0xFFB91C1C)),
  home:const App(),
));

class App extends StatefulWidget{
  const App({super.key});
  State<App> createState()=>S();
}

class S extends State<App>{
  bool loading=false;
  String? error;
  Map<String,dynamic>? data;

  void initState(){super.initState();fetch();}

  Future<void> fetch()async{
    setState((){
      loading=true;
      error=null;
      data=null;
    });

    try{
      final r=await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/invalid-post'));
      if(r.statusCode!=200){
        throw Exception('Invalid response: HTTP '+r.statusCode.toString());
      }
      data=jsonDecode(r.body);
    }catch(e){
      error='Unable to fetch API data.\n'+e.toString();
    }

    if(mounted)setState(()=>loading=false);
  }

  @override
  Widget build(BuildContext context)=>ApiPage(
    title:'API Error Handling',
    subtitle:'Connection/status errors with Retry',
    color:const Color(0xFFB91C1C),
    icon:Icons.error_outline_rounded,
    centered:true,
    child:loading
      ?const Center(
        child:Padding(
          padding:EdgeInsets.all(30),
          child:CircularProgressIndicator(),
        ),
      )
      :error!=null
        ?Column(children:[
          const Icon(Icons.cloud_off_rounded,size:62,color:Color(0xFFB91C1C)),
          const SizedBox(height:12),
          Text(error!,textAlign:TextAlign.center,
            style:const TextStyle(fontWeight:FontWeight.w700)),
          const SizedBox(height:18),
          FilledButton.icon(
            onPressed:fetch,
            icon:const Icon(Icons.refresh),
            label:const Text('Retry'),
          )
        ])
        :Text(data.toString()),
  );
}
