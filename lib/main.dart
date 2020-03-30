import 'dart:convert';

import 'package:covid19tracker/models/countryData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<CountryData> _data = [];
  // int _totalConfirmed;
  // int _totalDeaths;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('COVID19 Tracker'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: FlutterMap(
              options: MapOptions(
                minZoom: 0.0,
                maxZoom: 3.0,
                center: LatLng(40.71, -74.00),
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        'https://a.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(
                    markers: _data
                        .map<Marker>((item) => Marker(
                            point: LatLng(double.parse(item.lat),
                                double.parse(item.long)),
                            builder: (context) {
                              return IconButton(
                                icon: Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(item.name),
                                          content: Column(children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text('Total: ${item.cases}'),
                                                SizedBox(width: 5.0),
                                                Text(
                                                  '^${item.todayCases} New Cases',
                                                  style: TextStyle(
                                                      color: int.parse(item
                                                                  .todayCases) >
                                                              0
                                                          ? Colors.red
                                                          : Colors.black),
                                                ),
                                              ],
                                            ),
                                          ]),
                                        );
                                      });
                                },
                              );
                            }))
                        .toList()),
              ],
            ),
          ),
          Flexible(
            flex: 3,
            child: _getListView(context),
          )
        ],
      ),
    );
  }

  _getData() async {
    List<CountryData> _jsonData = [];
    var response =
        await http.get('https://corona.lmao.ninja/countries?sort=cases');
    var json = jsonDecode(response.body);
    print(json);
    for (var item in json) {
      CountryData _country = CountryData(
          item['countryInfo']['_id'].toString(),
          item['country'].toString(),
          item['countryInfo']['long'].toString(),
          item['countryInfo']['lat'].toString(),
          item['cases'].toString(),
          item['todayCases'].toString(),
          item['deaths'].toString(),
          item['todayDeaths'].toString(),
          item['recovered'].toString(),
          item['active'].toString(),
          item['critical'].toString(),
          item['countryInfo']['flag'].toString(),
          item['casesPerOneMillion'].toString(),
          item['deathsPerOneMillion'].toString());

      print(_country.name);
      _jsonData.add(_country);
    }

    setState(() {
      _data = _jsonData;
    });
  }

  Widget _getListView(BuildContext context) {
    return ListView.builder(
      itemCount: _data.length,
      itemBuilder: (builder, index) {
        final _item = _data[index];
        return Container(
          color: Colors.black,
          child: Card(
//            color: Colors.deepPurpleAccent,
            elevation: 5.0,
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.network(_item.flag),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${_item.name} : ${_item.cases}',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      '^${_item.todayCases}',
                      style: TextStyle(
                        color: (int.parse(_item.todayCases) > 0)
                            ? Colors.red
                            : Colors.green,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        'Total Cases: ${_item.cases}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15.0),
                      )),
                      Expanded(
                          child: Text(
                        "Today's New Cases: ${_item.todayCases}",
                        textAlign: TextAlign.center,
                      )),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
