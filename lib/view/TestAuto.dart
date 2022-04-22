import 'package:flutter/material.dart';
import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';

class Testauto extends StatefulWidget {
  @override
  State<Testauto> createState() => _TestautoState();
}

class _TestautoState extends State<Testauto> {
  List<Widget> pages = [FirstPage()];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
    );
  }
}
class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<String> added = [];
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  _FirstPageState() {
    textField = SimpleAutoCompleteTextField(
      key: key,
      decoration:
          InputDecoration(errorText: "Beans", hintText: "Type something"),
      controller: TextEditingController(),
      suggestions: suggestions,
      textChanged: (text) => currentText = text,
      clearOnSubmit: true,
      textSubmitted: (text) => setState(() {
        if (text != "") {
          added.add(text);
        }
      }),
    );
  }

  List<String> suggestions = [
    "Apple",
    "Armidillo",
    "Actual",
    "Actuary",
    "America",
    "Argentina",
    "Australia",
    "Antarctica",
    "Blueberry",
    "Cheese",
    "Danish",
    "Eclair",
    "Fudge",
    "Granola",
    "Hazelnut",
    "Ice Cream",
    "Jely",
    "Kiwi Fruit",
    "Lamb",
    "Macadamia",
    "Nachos",
    "Oatmeal",
    "Palm Oil",
    "Quail",
    "Rabbit",
    "Salad",
    "T-Bone Steak",
    "Urid Dal",
    "Vanilla",
    "Waffles",
    "Yam",
    "Zest"
  ];

  late SimpleAutoCompleteTextField textField;
  bool showWhichErrorText = false;

  @override
  Widget build(BuildContext context) {
    Column body = Column(children: [
      ListTile(
          title: textField,
          trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                textField.triggerSubmitted();
                showWhichErrorText = !showWhichErrorText;
                textField.updateDecoration(
                    decoration: InputDecoration(
                        errorText: showWhichErrorText ? "Beans" : "Tomatoes"));
              })),
    ]);

    body.children.addAll(added.map((item) {
      return ListTile(title: Text(item));
    }));

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar:
            AppBar(title: Text('AutoComplete TextField Demo Simple'), actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => showDialog(
                  builder: (_) {
                    String text = "";

                    return AlertDialog(
                        title: Text("Change Suggestions"),
                        content: TextField(onChanged: (_text) => text = _text),
                        actions: [
                          TextButton(
                              onPressed: () {
                                if (text != "") {
                                  suggestions.add(text);
                                  textField.updateSuggestions(suggestions);
                                }
                                Navigator.pop(context);
                              },
                              child: Text("Add")),
                        ]);
                  },
                  context: context))
        ]),
        body: body);
  }
}

class ArbitrarySuggestionType {
  //For the mock data type we will use review (perhaps this could represent a restaurant);
  num stars;
  String name, imgURL;

  ArbitrarySuggestionType(this.stars, this.name, this.imgURL);
}