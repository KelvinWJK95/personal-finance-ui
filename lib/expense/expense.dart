import '../utility/base.dart';
import 'item.dart';
import 'form.dart';

import 'package:http/http.dart' as http;

class Expense extends StatefulWidget {
  @override
  _ExpenseState createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  double _total = 0;
  final _entries = <Item>[];

  //testing data
  var arr = ['Foodpanda','Grab','Lazada','Shopee','Touch N Go', 'Digi', 'Mcdonalds', 'Netflix', 'Boost'];

  void _addEntry(String vendor, DateTime dateTime, double amount) {
    storeItem(vendor, dateTime, amount);
  }

  void storeItem(String vendor, DateTime dateTime, double amount) async {
    final response = await http.post(Uri.http(Common.url, 'api/entry'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'type': 'expense',
      'date': dateTime.toString(),
      'description': vendor,
      'amount': amount.toString(),
    }));

    if (response.statusCode == 201) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      var body = jsonDecode(response.body);

      if (this.mounted) {
        setState(() {
          _total += amount;
          _entries.insert(0, Item(key: UniqueKey(), id:body['id'], vendor: vendor, dateTime: dateTime, amount:amount, notifyParent: onDismissed));
        });
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to save expense');
    }
  }

  void fetchItem() async {
    final response = await http.get(Uri.http(Common.url, 'api/entry'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      loadFromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch expense');
    }
  }

  void loadFromJson(List<dynamic> list) {
    for (var json in list){
      var amount = json['amount'].toDouble();
      if (this.mounted) {
        setState(() {
          _total += amount;
          _entries.add(Item(key: UniqueKey(), id: json['id'], vendor: json['description'], dateTime: DateTime.parse(json['date']), amount: amount, notifyParent: onDismissed));
        });
      }
    }
  }

  onDismissed(item) async {
    var index = _entries.indexOf(item);

    final response = await http.delete(Uri.http(Common.url, 'api/entry/' + item.id.toString()));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      if (this.mounted) {
        setState(() {
          _total -= item.amount;
          _entries.removeAt(index);
        });
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to delete expense');
    }

  }

  @override
  void initState() {
    super.initState();
    fetchItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight*1.5,
        title:   ListTile(
          title: Text(
            getTranslated(context, 'total'),
            style: TextStyle(color: Colors.white)),
          subtitle: Text(
            getCurrencyFormat().format(_total),
            style: TextStyle(color: Colors.white, fontSize: 36.0))
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          indent: 15,
          endIndent: 15,
          height: 1,
          color: Colors.grey[400],
        ),
        // Let the ListView know how many items it needs to build.
        itemCount: _entries.length,
        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {
          return _entries[index];
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => ExpenseForm(addEntry: _addEntry),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = Offset(1, 0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return  SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
            }),
          );
          
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}


