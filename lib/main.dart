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
  LatLng _center;
  MapController _controller;
  // int _totalConfirmed;
  // int _totalDeaths;

  @override
  void initState() {
    super.initState();
    _controller = new MapController();
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
              mapController: _controller,
              options: MapOptions(
                zoom: 3,
                center: _center,
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
                                        return Dialog(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 250.0,
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          Colors.white,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              item.flag),
                                                    ),
                                                    SizedBox(
                                                      height: 20.0,
                                                    ),
                                                    Text(
                                                      item.name,
                                                      style: TextStyle(
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(width: 20.0),
                                                    Expanded(
                                                      child: Table(
                                                        border: TableBorder.all(
                                                            width: 1.0,
                                                            color:
                                                                Colors.black),
                                                        children: [
                                                          TableRow(children: [
                                                            TableCell(
                                                                child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <
                                                                  Widget>[
                                                                Text('Total Cases'),
                                                                Text(item.cases)
                                                              ],
                                                            )),
                                                          ]),
                                                          TableRow(children: [
                                                            TableCell(
                                                                child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <
                                                                  Widget>[
                                                                Text("Cases Today"),
                                                                Text(
                                                                  '^${item.todayCases}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: int.parse(item.todayCases) >
                                                                            0
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .green,
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                          ]),
                                                          TableRow(children: [
                                                            TableCell(
                                                                child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <
                                                                  Widget>[
                                                                Text("Total Deaths"),
                                                                Text(
                                                                  '${item.deaths}',
                                                                )
                                                              ],
                                                            )),
                                                          ]),
                                                          TableRow(children: [
                                                            TableCell(
                                                                child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <
                                                                  Widget>[
                                                                Text("Deaths Today"),
                                                                Text(
                                                                  '^${item.todayDeaths}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: int.parse(item.todayDeaths) >
                                                                            0
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .green,
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                          ]),
                                                          TableRow(children: [
                                                            TableCell(
                                                                child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <
                                                                  Widget>[
                                                                Text("Recovered"),
                                                                Text(
                                                                  '${item.recovered}',
                                                                )
                                                              ],
                                                            )),
                                                          ]),
                                                          TableRow(children: [
                                                            TableCell(
                                                                child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <
                                                                  Widget>[
                                                                Text("Actiive Cases"),
                                                                Text(
                                                                  '${item.active}',
                                                                )
                                                              ],
                                                            )),
                                                          ]),
                                                          TableRow(children: [
                                                            TableCell(
                                                                child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <
                                                                  Widget>[
                                                                Text("Critical Cases"),
                                                                Text(
                                                                  '${item.critical}',
                                                                )
                                                              ],
                                                            )),
                                                          ]),
                                                          TableRow(children: [
                                                            TableCell(
                                                                child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <
                                                                  Widget>[
                                                                Text("Cases/Mil"),
                                                                Text(
                                                                  '${item.casesPerMillion}',
                                                                )
                                                              ],
                                                            )),
                                                          ]),
                                                          TableRow(children: [
                                                            TableCell(
                                                                child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <
                                                                  Widget>[
                                                                Text("Deaths/Mil"),
                                                                Text(
                                                                  '${item.deathsPerMillion}',
                                                                )
                                                              ],
                                                            )),
                                                          ]),
                                                        ],
                                                        
                                                      ),
                                                    )
                                                  ]),
                                            ),
                                          ),
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
      _center = LatLng(double.parse(_data[0].lat), double.parse(_data[0].long));
    });
  }

  Widget _getListView(BuildContext context) {
    return ListView.builder(
      itemCount: _data.length,
      itemBuilder: (builder, index) {
        final _item = _data[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _center =
                  LatLng(double.parse(_item.lat), double.parse(_item.long));
              _controller.move(_center, 7.0);
            });

            print(_center);
          },
          child: Container(
            color: Colors.black,
            child: Card(
              elevation: 5.0,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(_item.flag),
                ),
                title: Text(_item.name),
                subtitle: Column(
                  children: <Widget>[
                    Row(children: [
                      Text('Total: ${_item.cases}'),
                      SizedBox(width: 10.0),
                      Text(
                        '(^${_item.todayCases} New Cases Today)',
                        style: TextStyle(
                          color: int.parse(_item.todayCases) > 0
                              ? Colors.red
                              : Colors.green,
                        ),
                      )
                    ]),
                    Row(children: [
                      Text('Total Deaths: ${_item.todayDeaths}'),
                      SizedBox(width: 10.0),
                      Text(
                        '(^${_item.todayDeaths} New Deaths Today)',
                        style: TextStyle(
                          color: int.parse(_item.todayCases) > 0
                              ? Colors.red
                              : Colors.green,
                        ),
                      )
                    ])
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}