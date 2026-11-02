import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_ui.dart';

void main()=>runApp(MaterialApp(
  debugShowCheckedModeBanner:false,
  theme:apiTheme(const Color(0xFFDB2777)),
  home:const Store(),
));

class Store extends StatefulWidget{
  const Store({super.key});
  State<Store> createState()=>S();
}

class S extends State<Store>{
  List products=[];
  String? error;

  void initState(){super.initState();fetch();}

  Future<void> fetch()async{
    try{
      final r=await http.get(
        Uri.parse('https://dummyjson.com/products?limit=12'));
      if(r.statusCode!=200)throw Exception('HTTP '+r.statusCode.toString());
      products=jsonDecode(r.body)['products'];
    }catch(e){
      error='Unable to load products';
    }
    if(mounted)setState((){});
  }

  @override
  Widget build(BuildContext context)=>ApiPage(
    title:'Product Store',
    subtitle:'REST API products • GridView • details',
    color:const Color(0xFFDB2777),
    icon:Icons.storefront_rounded,
    child:error!=null
      ?Column(children:[
        const Icon(Icons.error_outline,size:54,color:Colors.red),
        const SizedBox(height:10),
        Text(error!),
        FilledButton(onPressed:(){
          setState((){
            error=null;
            products=[];
          });
          fetch();
        },child:const Text('Retry')),
      ])
      :products.isEmpty
        ?const Center(
          child:Padding(
            padding:EdgeInsets.all(40),
            child:CircularProgressIndicator(),
          ),
        )
        :SizedBox(
          height:560,
          child:GridView.builder(
            gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:3,
              crossAxisSpacing:12,
              mainAxisSpacing:12,
              childAspectRatio:.78,
            ),
            itemCount:products.length,
            itemBuilder:(context,i){
              final p=products[i];
              return InkWell(
                borderRadius:BorderRadius.circular(18),
                onTap:()=>Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:(_)=>ProductDetail(id:p['id'] as int),
                  ),
                ),
                child:Card(
                  clipBehavior:Clip.antiAlias,
                  child:Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children:[
                      Expanded(
                        child:Container(
                          color:const Color(0xFFFDF2F8),
                          width:double.infinity,
                          child:Image.network(
                            p['thumbnail'].toString(),
                            fit:BoxFit.contain,
                            errorBuilder:(_,__,___)=>const Icon(
                              Icons.image_not_supported_outlined,size:48),
                          ),
                        ),
                      ),
                      Padding(
                        padding:const EdgeInsets.all(10),
                        child:Column(
                          crossAxisAlignment:CrossAxisAlignment.start,
                          children:[
                            Text(
                              p['title'].toString(),
                              maxLines:1,
                              overflow:TextOverflow.ellipsis,
                              style:const TextStyle(fontWeight:FontWeight.w800),
                            ),
                            const SizedBox(height:4),
                            Text(
                              '\$'+p['price'].toString(),
                              style:const TextStyle(
                                fontSize:17,
                                fontWeight:FontWeight.w900,
                                color:Color(0xFFDB2777),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
  );
}

class ProductDetail extends StatefulWidget{
  final int id;
  const ProductDetail({super.key,required this.id});
  State<ProductDetail> createState()=>DS();
}

class DS extends State<ProductDetail>{
  Map<String,dynamic>? product;
  String? error;

  void initState(){super.initState();fetch();}

  Future<void> fetch()async{
    try{
      final r=await http.get(
        Uri.parse('https://dummyjson.com/products/'+widget.id.toString()));
      if(r.statusCode!=200)throw Exception();
      product=jsonDecode(r.body);
    }catch(e){
      error='Unable to load product details';
    }
    if(mounted)setState((){});
  }

  @override
  Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const Text('Product Details')),
    body:error!=null
      ?Center(child:Column(
        mainAxisSize:MainAxisSize.min,
        children:[
          Text(error!),
          const SizedBox(height:10),
          FilledButton(onPressed:(){
            setState((){
              error=null;
              product=null;
            });
            fetch();
          },child:const Text('Retry')),
        ],
      ))
      :product==null
        ?const Center(child:CircularProgressIndicator())
        :Center(
          child:ConstrainedBox(
            constraints:const BoxConstraints(maxWidth:700),
            child:ListView(
              padding:const EdgeInsets.all(26),
              children:[
                SizedBox(
                  height:280,
                  child:Image.network(
                    product!['thumbnail'].toString(),
                    fit:BoxFit.contain,
                  ),
                ),
                const SizedBox(height:18),
                Text(product!['title'].toString(),
                  style:const TextStyle(fontSize:28,fontWeight:FontWeight.w900)),
                const SizedBox(height:8),
                Text('\$'+product!['price'].toString(),
                  style:const TextStyle(
                    fontSize:24,
                    fontWeight:FontWeight.w900,
                    color:Color(0xFFDB2777),
                  )),
                const SizedBox(height:14),
                Text(product!['description'].toString(),
                  style:const TextStyle(fontSize:16,height:1.5)),
              ],
            ),
          ),
        ),
  );
}
