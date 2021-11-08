import 'dart:developer';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Band> bands =[];
  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    _handleAvtiveBands(socketService);
    super.initState();
  }
  _handleAvtiveBands(SocketService socketService){
    socketService.socket.on('active-bands', (payload) {
      print(payload);
      this.bands = (payload as List).map((e) => Band.fromJson(e)).toList(); 
    });
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Band names", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        centerTitle: true,
        elevation: 10.0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.online
                ? const Icon(Icons.check_circle, color: Colors.blue)
                : const Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (BuildContext context, int index) => setList(bands[index]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: const Icon(Icons.add),
        onPressed: () {
          addNewBand(socketService);
          //Navigator.pushNamed(context, 'add-band');
        },
      ),
    );
  }

  Widget setList(Band band) {
    final socketService = Provider.of<SocketService>(context);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        print('direction: $direction');
        socketService.socket.emit('delete-band',band.id);
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
          socketService.socket.emit('vote-band',band.id);
          setState(() {
            
          });
        },
      ),
    );
  }

  addNewBand(SocketService socketService) {
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
                    addBandToList(_textController.text, socketService);
                    Navigator.pop(context);
                    setState(() {
                      
                    });
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
  addBandToList(String name,SocketService socketService){
    if (name !="") {
      socketService.socket.emit('add-band',name);
    }

  }
  Widget _showGraph(){
    Map<String,double> dataMap = new Map();
    for (var band in bands) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    }
    return Container(
      width: double.infinity,
      height: 200,
      child: !dataMap.isEmpty? PieChart(dataMap: dataMap,chartType: ChartType.ring,ringStrokeWidth: 10,):Text(' No hay datos apra mostrar'),
    );
  }
 }
