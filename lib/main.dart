import 'dart:convert';

import 'package:covid19tracker/models/countryData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<CountryData> _data = [];
  int _totalConfirmed;
  int _totalDeaths;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FlutterMap(
            options: MapOptions(
              minZoom: 0.0,
              maxZoom: 2.0,
              center: LatLng(40.71, -74.00),
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      'https://a.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c']),
              MarkerLayerOptions(markers: [
                Marker(
                    width: 100.0,
                    height: 100.0,
                    point: LatLng(40.71, -74.00),
                    builder: (context) => Container(
                          child: IconButton(
                              icon: Icon(Icons.location_on),
                              iconSize: 50.0,
                              color: Colors.red,
                              onPressed: () {}),
                        )),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  _getData() async {
    var response = await http
        .get('https://corona.lmao.ninja/countries?sort=cases');
    var json = jsonDecode(response.body);
    print(json);
  }
}
