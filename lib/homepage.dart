import 'dart:convert';

import 'package:covid19tracker/datasource.dart';
import 'package:covid19tracker/pages/countrypage.dart';
import 'package:covid19tracker/panels/infopanel.dart';
import 'package:covid19tracker/panels/mostaffectedcountries.dart';
import 'package:covid19tracker/panels/worldwidepanel.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  Map worldData;

  fetchWorldWideData() async {
    http.Response response = await http.get("https://www.disease.sh/v2/all");
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  List countryData;

  fetchcountryData() async {
    http.Response response =
        await http.get("https://corona.lmao.ninja/v2/countries?sort=cases");
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  void initState() {
    fetchWorldWideData();
    fetchcountryData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('COVID-19 TRACKER'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              height: 100,
              color: Colors.orange[100],
              child: Text(
                DataSource.quote,
                style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Worldwide',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CountryPage()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: primaryBlack,
                          borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Regional',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            worldData == null
                ? Center(child: CircularProgressIndicator())
                : WorldwidePanel(
                    worldData: worldData,
                  ),
            SizedBox(
              height: 10,
            ),
            worldData == null
                ? Container(
                    height: 20,
                  )
                : PieChart(
                    dataMap: {
                      'Confirmed': worldData['cases'].toDouble(),
                      'Active': worldData['active'].toDouble(),
                      'Recovered': worldData['recovered'].toDouble(),
                      'Deaths': worldData['deaths'].toDouble(),
                    },
                    colorList: [
                      Colors.red,
                      Colors.blue,
                      Colors.green,
                      Colors.grey[900],
                    ],
                  ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Most Affected Countries',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            countryData == null
                ? Container()
                : MostAffectedPanel(
                    countryData: countryData,
                  ),
            SizedBox(
              height: 25,
            ),
            InfoPanel(),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              'WE ARE TOGETHER IN THIS FIGHT',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            )),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
