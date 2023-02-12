import '../utility/base.dart';

class Item extends StatefulWidget {
  Item({Key key, @required this.dateTime, @required this.amount}) : super(key: key);

  final DateTime dateTime;
  final double amount;

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            children: <Widget>[
              ListTile(
                  title: Text(getDateFormat().format(widget.dateTime), style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
                  trailing: Text(getCurrencyFormat().format(widget.amount), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))
              )
            ],
          )
    );
  }
}