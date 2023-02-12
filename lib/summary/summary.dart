import '../utility/base.dart';
import 'expansion.dart';
import 'item.dart';

import 'package:http/http.dart' as http;

class Summary extends StatefulWidget {
  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  double _total = 0;
  final _entries = <Expansion>[];

  void fetchItem() async {
    final response = await http.get(Uri.http(Common.url, 'api/summary/daily'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      loadFromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch summary');
    }
  }

  void loadFromJson(Map<String, dynamic> json) {
    json.forEach((final String key, final value) {
      if (this.mounted) {
        var child = <Item>[];
        double total = 0;
        value.forEach((final String childKey, final childvalue) {
          var amount = double.tryParse(childvalue.replaceAll(",", "")).toDouble();
          total += amount;
          setState(() {
            _total += amount;
          });
          child.add(Item(key: UniqueKey(), dateTime: DateTime.parse(childKey), amount: amount));
        });
          
        _entries.add(Expansion(headerValue: DateTime.parse(key + '-01'), average: total, child: child));
      }
    });
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
      body: SingleChildScrollView(
        child: Container(
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _entries[index].isExpanded = !isExpanded;
              });
            },
            children: _entries.map<ExpansionPanel>((Expansion item) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text(getMonthFormat().format(item.headerValue)),
                    subtitle: Text('avg. '+getCurrencyFormat().format(item.average/item.child.length)),
                    trailing: Text('Total. '+getCurrencyFormat().format(item.average))
                  );
                },
                body: ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Divider(
                    indent: 15,
                    endIndent: 15,
                    height: 1,
                    color: Colors.grey[400],
                  ),
                  // Let the ListView know how many items it needs to build.
                  itemCount: item.child.length,
                  // Provide a builder function. This is where the magic happens.
                  // Convert each item into a widget based on the type of item it is.
                  itemBuilder: (context, index) {
                    return item.child[index];
                  },
                ),
                isExpanded: item.isExpanded,
              );
            }).toList(),
          )
        ),
      )
    );
  }
}


