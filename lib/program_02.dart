import 'package:flutter/material.dart';
import 'api_ui.dart';

void main()=>runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  theme:apiTheme(const Color(0xFF0F766E)),
  home:const App(),
));

Future<String> getValue()async{
  await Future.delayed(const Duration(seconds:2));
  return 'Future completed successfully!';
}

class App extends StatefulWidget{
  const App({super.key});
  State<App> createState()=>S();
}

class S extends State<App>{
  String result='Press the button to start Future';

  Future<void> run()async{
    setState(()=>result='Waiting...');
    final value=await getValue();
    setState(()=>result=value);
  }

  @override
  Widget build(BuildContext context)=>ApiPage(
    title:'Future • async • await',
    subtitle:'Value returned after a delay',
    color:const Color(0xFF0F766E),
    icon:Icons.schedule_rounded,
    centered:true,
    child:Column(children:[
      const Icon(Icons.hourglass_bottom_rounded,size:58,color:Color(0xFF0F766E)),
      const SizedBox(height:14),
      Text(result,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w700)),
      const SizedBox(height:18),
      FilledButton.icon(
        onPressed:run,
        icon:const Icon(Icons.play_arrow_rounded),
        label:const Text('Run Future'),
      )
    ]),
  );
}
