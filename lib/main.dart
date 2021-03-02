import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter Demo"),
        ),
        body: Center(
          child: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // The GlobalKey keeps track of the visible state of the list items
  // while they are being animated.
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  // backing data
  List<String> _data = ['Task 1', 'Task 2', 'Task 3'];

  @override
  Widget build(BuildContext context) {
    int totalSize;
    return Column(
      children: <Widget>[
        SizedBox(
          height: 520,
          child: AnimatedList(
            padding: EdgeInsets.all(8),
            key: _listKey,
            initialItemCount: _data.length,
            itemBuilder: (context, index, animation) {
              totalSize = index;
              return _buildItem(_data[index], animation);
            },
          ),
        ),
        FlatButton(
          child: Text('Add More Tasks',
              style: TextStyle(fontSize: 20, color: Colors.black)),
          onPressed: () {
            _insertSingleItem(totalSize);
          },
        ),
        RaisedButton(
          child: Text('Save Task List', style: TextStyle(fontSize: 20)),
          onPressed: () {
            //    _removeSingleItem();
          },
        )
      ],
    );
  }

  // This is the animated row with the Card.
  Widget _buildItem(String item, Animation animation) {
    String dropdownValue = 'Daily';
    bool _isChecked = false;

    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {

              return Checkbox(
                value: _isChecked,
                onChanged: (bool val) {
                  setState(() {
                    debugPrint("Checkbox");
                    _isChecked = val;

                  });
                },
              );
            }),
            Text(item),
            StatefulBuilder(
                builder: (BuildContext context, StateSetter setState)
                    {
                      return DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 12,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            debugPrint("dropdownValue");
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>['Daily', 'Weekly', 'Monthly', 'Quarterly']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      );
                    }
            ),

          ],
        ),
      ),
    );
  }

  void _insertSingleItem(int totalSize) {
    String newItem = "Task";
    // Arbitrary location for demonstration purposes
    int insertIndex = totalSize + 1;
    int insertNumber = _data.length + 1;

    // Add the item to the data list.
    _data.insert(insertIndex, "Task ${insertNumber.toString()}");
    // Add the item visually to the AnimatedList.
    _listKey.currentState.insertItem(insertIndex);
  }

  void _removeSingleItem() {
    int removeIndex = _data.length;
    // Remove item from data list but keep copy to give to the animation.
    String removedItem = _data.removeAt(removeIndex);
    // This builder is just for showing the row while it is still
    // animating away. The item is already gone from the data list.
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildItem(removedItem, animation);
    };
    // Remove the item visually from the AnimatedList.
    _listKey.currentState.removeItem(removeIndex, builder);
  }
}
