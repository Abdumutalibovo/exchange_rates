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

  List imageList=[
    myImages.AED_image,
    myImages.AUD_image,
    myImages.CAD_image,
    myImages.CHF_image,
    myImages.CNY_image,
    myImages.DKK_image,
    myImages.EGP_image,
    myImages.EUR_image,
    myImages.GBP_image,
    myImages.ISK_image,
    myImages.JPY_image,
    myImages.KRW_image,
    myImages.KWD_image,
    myImages.KZT_image,
    myImages.LBP_image,
    myImages.MTR_image,
    myImages.NOK_image,
    myImages.PLN_image,
    myImages.RUB_image,
    myImages.SEK_image,
    myImages.SGD_image,
    myImages.TRY_image,
    myImages.UAH_image,
    myImages.USD_image,
  ];

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
                            children: [
                              Image.asset(imageList[index], width: 30,),
                              SizedBox(width: 5,),
                              Text(
                                currencys?[index]?.code ?? "NO",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700)
                              ),
                              SizedBox(width: 270,),
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
