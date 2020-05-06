import 'networking.dart';

const apiUrl = 'https://api.coinbase.com/v2/exchange-rates';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class Rates {
  Map _rates;

  Rates() {
    getCoinPrices();
  }

  Future<bool> getCoinPrices() async {
    try {
      var json = await NetworkHelper().getJson(apiUrl);
      _rates = json['data']['rates'];
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Map getExchangeData(String from) {
    if (_rates != null) {
      Map exchangeData = {};

      for (String crypto in cryptoList) {
        if (from == 'USD') {
          exchangeData[crypto] =
              (double.parse(_rates[from]) / double.parse(_rates[crypto]))
                  .toStringAsFixed(2);
        } else {
          exchangeData[crypto] =
              ((double.parse(_rates[from]) / double.parse(_rates['USD'])) /
                      double.parse(_rates[crypto]))
                  .toStringAsFixed(2);
        }
      }

      return exchangeData;
    }
    return {};
  }
}
