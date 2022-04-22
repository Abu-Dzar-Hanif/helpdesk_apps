import 'package:flutter/material.dart';
class UserPage extends StatefulWidget {
  final VoidCallback signOut;
  @override
  UserPage(this.signOut);
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  sigOut(){
    setState(() {
      widget.signOut();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.1,backgroundColor: Colors.orange,title: Text('User Page'),actions: <Widget>[new IconButton(onPressed: (){
        sigOut();
      }, icon: Icon(Icons.double_arrow),color: Colors.white,),],
      ),
      body: Center(child: Text("Halaman User")),
    );
  }
}