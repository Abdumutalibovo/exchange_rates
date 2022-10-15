import 'dart:collection';
import 'dart:convert';

import 'package:exchange_money/models/currency.dart';
import 'package:exchange_money/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  Future<List<currencyModel?>?>? getResult;

  Future<List<currencyModel?>?>? getData() async {
    String url = "https://nbu.uz/uz/exchange-rates/json/";

    Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body) as List;

      List<currencyModel> currencys =
          json.map((e) => currencyModel.fromJson(e)).toList();
      return currencys;
    }

    return List.empty();
  }

  @override
  void initState() {
    super.initState();
    getResult = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Exchange rates",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<currencyModel?>?>(
          future: getResult,
          builder: (BuildContext context,
              AsyncSnapshot<List<currencyModel?>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.hasData) {
              List<currencyModel?>? currencys = snapshot.data;
              return ListView.builder(
                  itemCount: currencys?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Container(
                      width: double.infinity,
                      height: 100,
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                currencys?[index]?.code ?? "NO",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700)
                              ),
                              Icon(Icons.notifications_on_outlined)
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Cb curse",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "purchase",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "sell",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                currencys?[index]?.cb_price ?? "NO",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                currencys?[index]?.buy ?? "No",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                currencys?[index]?.cell ?? "NO",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
