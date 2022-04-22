import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:helpdesk_apps/view/Teknisi.dart';
// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';

class SearchTeknisi extends StatefulWidget {
  SearchTeknisi() : super();
  final String title = "AutoComplate Search Flutter";
  @override
  State<SearchTeknisi> createState() => _SearchTeknisiState();
}

class _SearchTeknisiState extends State<SearchTeknisi> {
  AutoCompleteTextField? searchTextField;
  GlobalKey<AutoCompleteTextFieldState<Teknisi>> key = new GlobalKey();
  static List<Teknisi> teknisis = new List<Teknisi>.from(<Teknisi>[]);
  bool loading = true;

  void getUsers() async{
    try{
      final response = await http.get(Uri.parse("http://192.168.43.38/apps_helpdesk/api/data_teknisi.php"));
      if (response.statusCode == 200){
        teknisis = loadUsers(response.body);
        print('Teknisi: ${teknisis.length}');
        setState(() {
          loading = false;
        });
      }else{
        print("Error getting Teknisi");
      }
    }catch(e){
      print("error getting data API");
    }
  }
  static List<Teknisi> loadUsers(String jsonString){
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<Teknisi>((json) => Teknisi.fromJson(json)).toList();
  }

  @override
  void initState(){
    getUsers();
    super.initState();
  }

  Widget row(Teknisi teknisi){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[Text(teknisi.nama_teknisi.toString(), style: TextStyle(fontSize: 16.0),),SizedBox(width: 10.0,),Text(teknisi.gender_teknisi.toString()),],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          loading ? CircularProgressIndicator() : searchTextField = AutoCompleteTextField<Teknisi>(
            key: key,clearOnSubmit: false,suggestions: teknisis,style: TextStyle(color: Colors.black,fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),hintText: "Cari Teknisi",hintStyle: TextStyle(color: Colors.black),),itemFilter: (item, query){
              return item.nama_teknisi!.toLowerCase().startsWith(query.toLowerCase());
            },
            itemSorter: (a,b){
              return a.nama_teknisi!.compareTo(b.nama_teknisi!);
            },
            itemSubmitted: (item){
              setState(() {
                searchTextField?.textField!.controller?.text = item.nama_teknisi.toString();
              });
            },
            itemBuilder: (context, item){
              return row(item);
            },
          )
        ],
      )
    );
  }
}