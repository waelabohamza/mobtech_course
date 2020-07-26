import 'package:flutter/material.dart';
import '../compount/mydrawer.dart';
 
class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      appBar: AppBar(
        title: Text("الاقسام"),
        centerTitle: true,
      ),
      drawer:MyDrawer() ,
      body: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2)
        ,children: <Widget>[
                // Start Cat One 
             InkWell(child:Card(child:  Column(children: <Widget>[
                 Expanded(child: Image.asset("images/logo/samlogo.png"),) , 
                 Container(child: Text("Samsung" , style: TextStyle(fontSize: 20  ),))
             ],),) , onTap: (){
                     Navigator.of(context).pushNamed("samsung") ; 
             },) , 
             InkWell(child:Card(child:  Column(children: <Widget>[
                 Expanded(child: Image.asset("images/logo/xia.png"),) , 
                 Container(child: Text("Xiaomi" , style: TextStyle(fontSize: 20 ),))
             ],),) , onTap: (){},) , 
             InkWell(child:Card(child:  Column(children: <Widget>[
                 Expanded(child: Image.asset("images/logo/oppo.png"  ),) , 
                 Container(child: Text("oppo" , style: TextStyle(fontSize: 20 ),))
             ],),), onTap: (){}) ,
             InkWell(child:Card(child:  Column(children: <Widget>[
                 Expanded(child: Image.asset("images/logo/hua.png"    ),) , 
                 Container(child: Text("Huawei" , style: TextStyle(fontSize: 20 ),))
             ],),), onTap: (){}) , 
             InkWell(child:Card(child:  Column(children: <Widget>[
                 Expanded(child: Image.asset("images/logo/realme.jpg" , ),) , 
                 Container(child: Text("Realme" , style: TextStyle(fontSize: 20 ),))
             ],),), onTap: (){}) ,  // End Cat one 
             InkWell(child:Card(child:  Column(children: <Widget>[
                 Expanded(child: Image.asset("images/logo/apple.png"   , width: MediaQuery.of(context).size.width / 4, height: 100, ),) , 
                 Container(child: Text("Apple" , style: TextStyle(fontSize: 20 ),))
             ],),), onTap: (){}) , 
      ],),
    ));
  }
}