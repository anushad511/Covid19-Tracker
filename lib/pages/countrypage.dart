import 'dart:convert';

import 'package:covid19tracker/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../homepage.dart';

class CountryPage extends StatefulWidget {
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  List countryData;

  fetchcountryData() async {
    http.Response response =
        await http.get("https://corona.lmao.ninja/v2/countries?sort=cases");
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  void initState() {
    fetchcountryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: Search(countryData));
              },
            )
          ],
          title: Text('Country Stats'),
        ),
        body: countryData == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: Container(
                      height: 130,
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[100],
                            blurRadius: 10,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Card(
                            child: Container(
                              // width: 200,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(countryData[index]['country'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Image.network(
                                    countryData[index]['countryInfo']['flag'],
                                    width: 60,
                                    height: 50,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'CONFIRMED:' +
                                        countryData[index]['cases'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                  Text(
                                    'ACTIVE:' +
                                        countryData[index]['active'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                  Text(
                                      'RECOVERED:' +
                                          countryData[index]['recovered']
                                              .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green)),
                                  Text(
                                      'DEATHS:' +
                                          countryData[index]['deaths']
                                              .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800])),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: countryData == null ? 0 : countryData.length,
              ));
  }
}
