import '../utility/base.dart';

class Item extends StatefulWidget {
  Item({Key key, @required this.id, @required this.vendor, @required this.dateTime, @required this.amount, @required this.notifyParent}) : super(key: key);

  final int id;
  final String vendor;
  final DateTime dateTime;
  final double amount;
  Function(Item) notifyParent;

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Dismissible(
          background: Container(
            color: Colors.red,
          ),
          key:UniqueKey(),
          child: Column(
            children: <Widget>[
              ListTile(
                  title: Text(widget.vendor),
                  subtitle: Text(getDateTimeFormat().format(widget.dateTime)),
                  trailing: Text(getCurrencyFormat().format(widget.amount))
              )
            ],
          ),
          onDismissed: (direction){
             widget.notifyParent(widget);
          }
        ) 
    );
  }
}