import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_ui.dart';

void main()=>runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  theme:apiTheme(const Color(0xFF4F46E5)),
  home:const UserList(),
));

class UserList extends StatefulWidget{
  const UserList({super.key});
  State<UserList> createState()=>S();
}

class S extends State<UserList>{
  List users=[];

  void initState(){super.initState();fetch();}

  Future<void> fetch()async{
    final r=await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'));
    users=jsonDecode(r.body);
    if(mounted)setState((){});
  }

  @override
  Widget build(BuildContext context)=>ApiPage(
    title:'Users',
    subtitle:'Tap a user to view complete details',
    color:const Color(0xFF4F46E5),
    icon:Icons.people_alt_rounded,
    child:SizedBox(
      height:440,
      child:users.isEmpty
        ?const Center(child:CircularProgressIndicator())
        :ListView.builder(
          itemCount:users.length,
          itemBuilder:(context,i){
            final u=users[i];
            return Card(
              child:ListTile(
                leading:CircleAvatar(
                  child:Text(u['name'].toString().substring(0,1)),
                ),
                title:Text(u['name'].toString()),
                subtitle:Text(u['email'].toString()),
                trailing:const Icon(Icons.chevron_right),
                onTap:()=>Navigator.push(
                  context,
                  MaterialPageRoute(builder:(_)=>UserDetail(user:u)),
                ),
              ),
            );
          },
        ),
    ),
  );
}

class UserDetail extends StatelessWidget{
  final Map<String,dynamic> user;
  const UserDetail({super.key,required this.user});

  @override
  Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('User Details')),
    body:Center(
      child:ConstrainedBox(
        constraints:const BoxConstraints(maxWidth:650),
        child:ListView(
          padding:const EdgeInsets.all(24),
          children:[
            CircleAvatar(
              radius:42,
              child:Text(user['name'].toString().substring(0,1),
                style:const TextStyle(fontSize:28)),
            ),
            const SizedBox(height:18),
            Text(user['name'].toString(),
              textAlign:TextAlign.center,
              style:const TextStyle(fontSize:27,fontWeight:FontWeight.w800)),
            const SizedBox(height:20),
            Card(child:Column(children:[
              ListTile(
                leading:const Icon(Icons.email_outlined),
                title:const Text('Email'),
                subtitle:Text(user['email'].toString()),
              ),
              ListTile(
                leading:const Icon(Icons.phone_outlined),
                title:const Text('Phone'),
                subtitle:Text(user['phone'].toString()),
              ),
              ListTile(
                leading:const Icon(Icons.language),
                title:const Text('Website'),
                subtitle:Text(user['website'].toString()),
              ),
              ListTile(
                leading:const Icon(Icons.business_outlined),
                title:const Text('Company'),
                subtitle:Text(user['company']['name'].toString()),
              ),
              ListTile(
                leading:const Icon(Icons.location_on_outlined),
                title:const Text('Address'),
                subtitle:Text(
                  user['address']['street'].toString()+', '+
                  user['address']['city'].toString(),
                ),
              ),
            ])),
          ],
        ),
      ),
    ),
  );
}
