import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

main() {
  runApp(MyProflie());
}

String input_p_size = 'S';
double result = 0.0;
List<food> order = [];
List<food> order_filter = [];


class MyProflie extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Pizza',
      home: StatefulHomePage(),
    );
  }
}

class food {
  final String p_name;
  final double p_price;
  final String p_size;

  food(this.p_name, this.p_price, this.p_size);
}

class StatefulHomePage extends StatefulWidget{
  @override
  _StatefulHomePageState createState() => _StatefulHomePageState();
}
  

class _StatefulHomePageState extends State<StatefulHomePage>{

  static String dropdownValue = 'S';
  String selected = "";
  String _input_p_name;
  double _input_p_price;

  TextEditingController _c_name = TextEditingController(text: "");
  TextEditingController _c_price = TextEditingController(text: "");
  TextEditingController _c_size = TextEditingController(text: "");
  final TextEditingController searchfield = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  List<food> order = [];
  List<food> order_filter = [];

  @override
  Widget build(BuildContext context) {
    
    Future<void> _alerts() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return buildAlertDialog(context);
        },
      );
    }

    Future<void> _alertsresult() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return resultshow(context);
        },
      );
    }    

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _alerts,
              ),
              // action button
              IconButton(
                icon: Icon(Icons.monetization_on),
                onPressed: _alertsresult,
              ),
            ], 

            title: Text('Pizza'),
          ),
      body: Column(
            children: <Widget>[
                  Container( child: ListTile(
                      leading: Icon(
                        Icons.search,
                      ),
                      title: TextField(
                        controller: searchfield,
                        decoration: InputDecoration(
                          hintText: "Find Pizza",
                          border: InputBorder.none 
                        ),
                       onChanged: onSearchTextChanged, 
                      ),
                      trailing: new IconButton(icon: new Icon(Icons.clear), onPressed: () {
                      searchfield.clear();
                      onSearchTextChanged('');
                  },),
                    )
                  ),
                   Expanded(
                      child: order_filter.length == 0
                      ? Container(
                          alignment: Alignment.center,
                          child: Text(
                            'No data',
                          ),
                        )
                      : ListView.builder(
                          itemCount: order_filter.length,
                          itemBuilder: (
                            BuildContext context,
                            int index,
                          ) {
                            return ListTile(
                              title: DataCard(
                                  order_filter[index].p_name,
                                  (order_filter[index].p_price).toString(),
                                  order_filter[index].p_size),
                              onTap: () {
                                // _list_tap(order_filter[index], index);
                              },
                            );
                          },
                        ),
            ),
                ],
      )    
    );
  }

  AlertDialog resultshow(BuildContext context){
    String resultS = (result+(result*0.07)).toString();
    return AlertDialog(
      title: Text('Pizza Price'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Text('Your Priec : '+ resultS)
            ),
            RaisedButton(
              color: Colors.white,
              textColor: Colors.blue,
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                },
            ),
          ],
        ),
      ),    
    );
  }

  AlertDialog buildAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Add Pizza'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _formkey,
              child: Column(
                children: <Widget>[

                  TextFormField(
                    onSaved: (String value) {
                      _input_p_name = value;
                    },
                    // controller: TextEditingController(text: ""),
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  TextFormField(
                    onSaved: (String value) {
                      _input_p_price = double.parse(value);
                    },
                    // controller: TextEditingController(text: ""),
                    decoration: InputDecoration(
                      labelText: 'Price',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter(
                        RegExp('[0123456789.]'),
                      )
                    ],
                  ),
                  
                ],
              ),
            ),
            Row(
                    children: <Widget>[
                      Text("Size: "),
                      Build_dropList(),
                    ],
                  )
          ],
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          color: Colors.white,
          onPressed: () {
            _formkey.currentState.save();
            setState(() {
              order.insert(order.length,
                  food(_input_p_name, _input_p_price, input_p_size));
            });
            _formkey.currentState.reset();
            filterSearchResults(selected);
            Navigator.of(context).pop();
            // print('$_inputName : $_inputtext');
          },
          child: Text('Add'),
        ),
        RaisedButton(
          color: Colors.white,
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

    void filterSearchResults(String query) {
   List<food> filter_list = [];
    filter_list.addAll(order);
    if (query != "") {
      List<food> dummyListData = [];
      filter_list.forEach((item) {
        if (item.p_name == query) {
          dummyListData.add(item);
        }
      });
      setState(() {
        order_filter.clear();
        order_filter.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        order_filter.clear();
        order_filter.addAll(order);
      });
    }
  }

onSearchTextChanged(String query) async {
    List<food> filter_list = [];
    filter_list.addAll(order);
    if (query.isNotEmpty) {
      List<food> dummyListData = [];
      filter_list.forEach((item) {
        if (item.p_name.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        order_filter.clear();
        order_filter.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        order_filter.clear();
        order_filter.addAll(order);
      });
    }
  }

}


class DataCard extends StatelessWidget {
  final String _title, _priece, _siza;
  const DataCard(
    // this._url,
    this._title,
    this._priece,
    this._siza,
     {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5),
      color: Colors.white,
      elevation: 15,
      child: Row (
        children: <Widget>[
          Container(
             margin: EdgeInsets.all(5),
             padding: EdgeInsets.all(10),
             child: Image.network(
               'https://1112.minorcdn.com/1112/public/images/products/pizza/website/Pan_Meat-Deluxe.png',width: 100,height: 100,
             ),
           ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 120,
                //margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text(
                    'Name : $_title',
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                        fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                  )
              ),
              SizedBox(
                width: 120,
                child: Text(
                  'Price : $_priece',
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
              Container(
                child: Text(
                  'Size : $_siza',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(10),
            child: RaisedButton(   
                    color: Colors.green[200],
                    onPressed: () {
                      Toast.show("Bought It!!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                      result = result+double.parse(_priece);
                    },
                    child: Text('Buy'),
                  ),
          ),
        ],
      ),
    );
  }
}

class Build_dropList extends StatefulWidget {
  @override
  _Build_dropListState createState() => _Build_dropListState();
}

class _Build_dropListState extends State<Build_dropList> {
  String B_Size = 'Small';
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: input_p_size = B_Size,
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.blue),
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: (String newValue) {
        setState(() {
          input_p_size = B_Size = newValue;
          // Navigator.of(context).pop();
        });
      },
      items: <String>['Small', 'Medium', 'Large']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
