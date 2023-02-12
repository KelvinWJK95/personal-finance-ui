import '../utility/base.dart';

class ExpenseForm extends StatefulWidget {
  final Function(String, DateTime, double) addEntry;
  ExpenseForm({Key key, @required this.addEntry}) : super(key: key);

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  DateTime _dateTime;

  final _dateController = TextEditingController();
  final _vendorController = TextEditingController();
  final _amountController = TextEditingController();

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(new DateTime.now().year-5),
        lastDate: new DateTime(new DateTime.now().year+5)
    );
    if(picked != null){
      _dateTime = picked;
      _dateController.text = getDateTimeFormat().format(picked);

      _selectTime();
    }
  }

  Future _selectTime() async {
    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null){
      DateTime dateTime = new DateTime(_dateTime.year, _dateTime.month, _dateTime.day, picked.hour, picked.minute);

      _dateTime = dateTime;
      _dateController.text = getDateTimeFormat().format(_dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 10,
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Scaffold(
      appBar: AppBar( 
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          getTranslated(context, 'expense'),
          style: TextStyle(
            color: Colors.black
          )
        ),
      ),
      body: Column(
        children: <Widget>[
          Form(
            child: Padding(
              padding:EdgeInsets.all(25.0),
              child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _vendorController,
                      decoration: InputDecoration(
                        labelText: getTranslated(context, 'tag'),
                        contentPadding: EdgeInsets.all(5.0),
                      ),
                      validator: (String value) {
                        return value.contains('@') ? 'Do not use the @ char.' : null;
                      }
                    ),
                    SizedBox(height: 25),
                    TextFormField(
                      controller: _dateController,
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode()); // to stop keyboard
                        _selectDate();   // Call Function that has showDatePicker()
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        contentPadding: EdgeInsets.all(5.0),
                      ),
                    ),
                    SizedBox(height: 25),
                    TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: getTranslated(context, 'currency'),
                        contentPadding: EdgeInsets.all(5.0),
                      ),
                      keyboardType: TextInputType.number,
                    )
                  ],
                )
            ),
          ), 
          Spacer(),
          Container(
            height: 50,
            width: double.infinity,
            child: FlatButton(
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                /*...*/
                widget.addEntry(_vendorController.text, _dateTime, double.parse(_amountController.text));
                Navigator.pop( context );
              },
              child: Text(
                "Save",
                 style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
                )
              ),
            )
          )
        ]
      ),
    ),

    );
  }
}