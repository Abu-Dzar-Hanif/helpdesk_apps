import 'package:flutter/material.dart';
import 'package:helpdesk_apps/model/api.dart';
import 'package:helpdesk_apps/model/TiketModel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'dart:convert';

class SearchTiket extends StatefulWidget {
  const SearchTiket({Key? key}) : super(key: key);
  @override
  State<SearchTiket> createState() => _SearchTiketState();
}

class _SearchTiketState extends State<SearchTiket> {
  AutoCompleteTextField? searchTextField;
  GlobalKey<AutoCompleteTextFieldState<TiketModel>> key = new GlobalKey();
  static List<TiketModel> Tiket = new List<TiketModel>.from(<TiketModel>[]);
  bool loading = true;
  void getTiket() async {
    try {
      final response = await http.get(Uri.parse(BaseUrl.urlDataTiket));
      if (response.statusCode == 200) {
        Tiket = loadTiket(response.body);
        setState(() {
          loading = false;
        });
      } else {
        print("Error getting Tiket");
      }
    } catch (e) {
      print("error getting data API");
    }
  }

  static List<TiketModel> loadTiket(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<TiketModel>((json) => TiketModel.fromJson(json)).toList();
  }

  @override
  void initState() {
    getTiket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 41, 69, 91),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "Cek Tiket",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              )
            ],
          ),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              loading
                  ? Center(child: CircularProgressIndicator())
                  : searchTextField = AutoCompleteTextField<TiketModel>(
                      key: key,
                      clearOnSubmit: false,
                      suggestions: Tiket,
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                        hintText: " Cek Tiket",
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                      itemFilter: (item, query) {
                        return item.id_tiket!
                            .toLowerCase()
                            .startsWith(query.toLowerCase());
                      },
                      itemSorter: (a, b) {
                        return a.id_tiket!.compareTo(b.id_tiket!);
                      },
                      itemSubmitted: (item) {},
                      itemBuilder: (context, item) {
                        return _buildContainer(item);
                      },
                    )
            ]));
  }

  Widget _buildContainer(TiketModel Tikets) {
    return Container(
      padding: EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              "ID : " + Tikets.id_tiket.toString(),
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              "User : " + Tikets.nama_karyawan.toString(),
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text("Status" + Tikets.sts.toString()),
          ],
        ),
      ),
    );
  }
}
