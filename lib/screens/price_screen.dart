import 'dart:io' show Platform;

import '../services/rates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  bool isFetching = true;
  String selectedCurrency = 'USD';
  Rates rates = Rates();
  Map exchangeData;

  DropdownButton androidDropdown() {
    List<DropdownMenuItem> dropdownlist = [];

    for (String currency in currenciesList) {
      dropdownlist.add(DropdownMenuItem(
        child: Text(currency),
        value: currency,
      ));
    }

    return DropdownButton(
      value: selectedCurrency,
      items: dropdownlist,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          exchangeData = rates.getExchangeData(selectedCurrency);
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerList = [];

    for (String currency in currenciesList) {
      pickerList.add(
        Text(
          currency,
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      children: pickerList,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        exchangeData = rates.getExchangeData(selectedCurrency);
      },
    );
  }

  void dumpData() async {
    await rates.getCoinPrices();
    setState(() {
      isFetching = false;
    });

    exchangeData = rates.getExchangeData(selectedCurrency);
  }

  List<Card> getCryptoCardList() {
    List<Card> cryptoCardList = [];
    for (String crypto in cryptoList) {
      cryptoCardList.add(
        Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 $crypto = ${exchangeData[crypto]} $selectedCurrency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    return cryptoCardList;
  }

  @override
  void initState() {
    super.initState();
    dumpData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: isFetching
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'hold on!',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: getCryptoCardList(),
                    )),
                Container(
                  height: 150.0,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 30.0),
                  color: Colors.lightBlue,
                  child: Platform.isIOS ? iosPicker() : androidDropdown(),
                ),
              ],
            ),
    );
  }
}
