import 'dart:developer';

import 'package:band_names/models/band.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 0),
    Band(id: '2', name: 'Queen', votes: 0),
    Band(id: '3', name: 'Iron Maiden', votes: 0)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Band names", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        centerTitle: true,
        elevation: 10.0,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index) => setList(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: const Icon(Icons.add),
        onPressed: () {
          addNewBand();
          //Navigator.pushNamed(context, 'add-band');
        },
      ),
    );
  }

  Widget setList(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction){
        print('direction: $direction');
      },
      background: Container(
        padding: const EdgeInsets.only(left: 10),
        color: Colors.red,
        child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Delete Band',
              style: TextStyle(color: Colors.white),
            )),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text(
          band.votes.toString(),
          style: const TextStyle(fontSize: 20),
        ),
        onTap: () {
          setState(() {
            band.votes++;
          });
        },
      ),
    );
  }

  addNewBand() {
    final _textController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New band name'),
            content: TextField(
              controller: _textController,
            ),
            actions: <Widget>[
              MaterialButton(
                  elevation: 5,
                  textColor: Colors.blue[600],
                  child: const Text('Add'),
                  onPressed: () {
                    onPressedButton(_textController);
                  }),
              MaterialButton(
                elevation: 5,
                textColor: Colors.red[700],
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  onPressedButton(TextEditingController tec) {
    if (tec.text != '') {
      bands.add(Band(id: DateTime.now().toString(), name: tec.text));
      setState(() {});
    }

    Navigator.pop(context);
  }
}
