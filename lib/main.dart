import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<List<dynamic>> traceData;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();

  List<PlatformFile>? _paths;
  final String? _extensionFile = 'csv';
  final FileType _pickingType = FileType.custom;
  var attToggle1 = Colors.blue;
  var attToggle2 = Colors.blue;
  var attToggle3 = Colors.blue;
  var attToggle4 = Colors.blue;
  var attToggle5 = Colors.blue;
  var attToggle6 = Colors.blue;
  var attToggle7 = Colors.blue;
  var attToggle8 = Colors.blue;

  AttributeIDs setID = AttributeIDs('0000', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty');
  List<AttributeIDs> listOfID = [];
  bool toggleBtt = false;

  List<TableRow> tableDisplay = [
    const TableRow(
      decoration: BoxDecoration(
          color: Colors.red
        ),
      children: [
        Text('ID', textAlign: TextAlign.center),
        Text('Attribute #1', textAlign: TextAlign.center),
        Text('Attribute #2', textAlign: TextAlign.center),
        Text('Attribute #3', textAlign: TextAlign.center),
        Text('Attribute #4', textAlign: TextAlign.center),
        Text('Attribute #5', textAlign: TextAlign.center),
        Text('Attribute #6', textAlign: TextAlign.center),
        Text('Attribute #7', textAlign: TextAlign.center),
        Text('Attribute #8', textAlign: TextAlign.center)
      ]
    )
  ];


  @override
  void initState() {
    super.initState();
    traceData = List<List<dynamic>>.empty(growable: true);
  }

  openFile(filepath) async {
    File f = new File(filepath);
    final input = f.openRead();
    final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
    print(fields);
    setState(() {
      traceData = fields;
    });
  }

  void _openFileExplorer() async {
    try{
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,
        allowedExtensions: (_extensionFile?.isNotEmpty ??false)
            ? _extensionFile?.replaceAll('','').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch(e) {
      print(e.toString());
    } catch (ex) {
      print(ex);
    }
    if(!mounted) return;
    setState(() {
      openFile(_paths![0].path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("IDs' Attributes Addition"),
        ),
        body: Column(
          children: [

            //First Part: ID Input
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 500,
                  child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(0.8),
                        child: TextFormField(
                            decoration: const InputDecoration(
                                icon: Icon(Icons.numbers),
                                hintText: 'Please Enter the ID',
                                labelText: 'ID'
                            ),
                            keyboardType: TextInputType.text,
                            controller: _idController,
                            validator: (val) => val!.isEmpty ? 'ID is required' : null
                        ),
                      )
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: 150,
                  child: ElevatedButton(
                      onPressed: (){
                        setState(() {
                          if(_formKey.currentState!.validate()) {
                            setID.id = _idController.text;
                            print(setID.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('The ID is entered successfully'))
                            );
                          }else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Invalid ID'))
                            );
                          }
                          _idController.text = '';
                        });
                      },
                      child: const Text('Enter the ID')
                  ),
                )
              ],
            ),
            //Just For showing the entered ID
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(setID.id=='0000' ? 'ID is Empty': 'ID: ${setID.id}', style:const TextStyle(color: Colors.deepOrange, fontSize: 20, fontWeight: FontWeight.bold)),
            ),

            //Second Part. Picking imported attributes from a CSV file
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: attToggle1
                          ),
                          onPressed: traceData.isEmpty ? null: () => setState(() {
                            if(attToggle1 == Colors.blue) {
                              setID.attributeNo1 = traceData[0][0];
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('The Attribute #1 is added.'), duration: Duration(seconds: 1))
                              );
                              attToggle1 = Colors.red;
                            } else {
                              setID.attributeNo1 = 'Empty';
                              attToggle1 = Colors.blue;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('The Attribute #1 is removed.'), duration: Duration(seconds: 1))
                              );
                            }
                          }),
                          child: Text(traceData.isEmpty ? 'Empty': traceData[0][0]),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: attToggle2
                          ),
                          onPressed: traceData.length<2 ? null: () => setState(() {
                            if(attToggle2 == Colors.blue) {
                              setID.attributeNo2 = traceData[1][0];
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('The Attribute #2 is added.'), duration: Duration(seconds: 1))
                              );
                              attToggle2 = Colors.red;
                            } else {
                              setID.attributeNo2 = 'Empty';
                              attToggle2 = Colors.blue;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('The Attribute #2 is removed.'), duration: Duration(seconds: 1))
                              );
                            }
                          }),
                          child: Text(traceData.length<2 ? 'Empty': traceData[1][0]),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: attToggle3
                          ),
                          onPressed: traceData.length<3 ? null: () => setState(() {
                            if(attToggle3 == Colors.blue) {
                              setID.attributeNo3 = traceData[2][0];
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('The Attribute #3 is added.'), duration: Duration(seconds: 1))
                              );
                              attToggle3 = Colors.red;
                            } else {
                              setID.attributeNo3 = 'Empty';
                              attToggle3 = Colors.blue;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('The Attribute #3 is removed.'), duration: Duration(seconds: 1))
                              );
                            }
                          }),
                          child: Text(traceData.length<3 ? 'Empty': traceData[2][0]),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: attToggle4
                          ),
                          onPressed: traceData.length<4 ? null: () => setState(() {
                            if(attToggle4 == Colors.blue) {
                              setID.attributeNo4 = traceData[3][0];
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('The Attribute #4 is added.'), duration: Duration(seconds: 1))
                              );
                              attToggle4 = Colors.red;
                            } else {
                              setID.attributeNo4 = 'Empty';
                              attToggle4 = Colors.blue;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('The Attribute #4 is removed.'), duration: Duration(seconds: 1))
                              );
                            }
                          }),
                          child: Text(traceData.length<4 ? 'Empty': traceData[3][0]),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: attToggle5
                          ),
                          onPressed: traceData.length<5 ? null: () => setState(() {
                            if(attToggle5 == Colors.blue) {
                              setID.attributeNo5 = traceData[4][0];
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('The Attribute #5 is added.'), duration: Duration(seconds: 1))
                              );
                              attToggle5 = Colors.red;
                            } else {
                              setID.attributeNo5 = 'Empty';
                              attToggle5 = Colors.blue;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('The Attribute #5 is removed.'), duration: Duration(seconds: 1))
                              );
                            }
                          }),
                          child: Text(traceData.length<5 ? 'Empty': traceData[4][0]),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: attToggle6
                          ),
                          onPressed: traceData.length<6 ? null: () => setState(() {
                            if(attToggle6 == Colors.blue) {
                              setID.attributeNo6 = traceData[5][0];
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('The Attribute #6 is added.'), duration: Duration(seconds: 1))
                              );
                              attToggle6 = Colors.red;
                            } else {
                              setID.attributeNo6 = 'Empty';
                              attToggle6 = Colors.blue;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('The Attribute #6 is removed.'), duration: Duration(seconds: 1))
                              );
                            }
                          }),
                          child: Text(traceData.length<6 ? 'Empty': traceData[5][0]),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: attToggle7
                          ),
                          onPressed: traceData.length<7 ? null: () => setState(() {
                            if(attToggle7 == Colors.blue) {
                              setID.attributeNo7 = traceData[6][0];
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('The Attribute #7 is added.'), duration: Duration(seconds: 1))
                              );
                              attToggle7 = Colors.red;
                            } else {
                              setID.attributeNo7 = 'Empty';
                              attToggle7 = Colors.blue;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('The Attribute #7 is removed.'), duration: Duration(seconds: 1))
                              );
                            }
                          }),
                          child: Text(traceData.length<7 ? 'Empty': traceData[6][0]),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: attToggle8
                          ),
                          onPressed: traceData.length<8 ? null: () => setState(() {
                            if(attToggle8 == Colors.blue) {
                              setID.attributeNo8 = traceData[7][0];
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('The Attribute #8 is added.'), duration: Duration(seconds: 1))
                              );
                              attToggle8 = Colors.red;
                            } else {
                              setID.attributeNo8 = 'Empty';
                              attToggle8 = Colors.blue;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('The Attribute #8 is removed.'), duration: Duration(seconds: 1))
                              );
                            }
                          }),
                          child: Text(traceData.length<8 ? 'Empty': traceData[7][0]),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0,8.0,15.0,20.0),
              child: Container(
                height: 40,
                width: 120,
                color: Colors.teal,
                child: TextButton(
                    onPressed: (){
                      if(setID.getIDs() != '0000') {
                        var attList = AttributeIDs(setID.getIDs(), setID.getAtt1(), setID.getAtt2(), setID.getAtt3(),
                            setID.getAtt4(), setID.getAtt5(), setID.getAtt6(), setID.getAtt7(), setID.getAtt8());
                        listOfID.add(attList);
                        print(listOfID.toString());
                        setState(() {
                          tableDisplay.add(TableRow(
                              children: [
                                Text(attList.getIDs(), textAlign: TextAlign.center),
                                Text(attList.getAtt1(), textAlign: TextAlign.center),
                                Text(attList.getAtt2(), textAlign: TextAlign.center),
                                Text(attList.getAtt3(), textAlign: TextAlign.center),
                                Text(attList.getAtt4(), textAlign: TextAlign.center),
                                Text(attList.getAtt5(), textAlign: TextAlign.center),
                                Text(attList.getAtt6(), textAlign: TextAlign.center),
                                Text(attList.getAtt7(), textAlign: TextAlign.center),
                                Text(attList.getAtt8(), textAlign: TextAlign.center),
                              ]
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('The ID is successfully saved'))
                          );
                          setID = AttributeIDs('0000', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty', 'Empty');
                          attToggle1 = Colors.blue;
                          attToggle2 = Colors.blue;
                          attToggle3 = Colors.blue;
                          attToggle4 = Colors.blue;
                          attToggle5 = Colors.blue;
                          attToggle6 = Colors.blue;
                          attToggle7 = Colors.blue;
                          attToggle8 = Colors.blue;
                        });
                      }
                    },
                    child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 20),)
                ),
              ),
            ),


            //Third Part. Three buttons for importing a CSV file, showing/hiding saved IDs, and exiting the application
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    color: Colors.green,
                    height: 30,
                    width: 150,
                    child: TextButton(
                      onPressed: _openFileExplorer,
                      child: const Text('Import a CSV File', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    color: Colors.green,
                    height: 30,
                    width: 200,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          if(toggleBtt == false) {
                            toggleBtt = true;
                          }else {
                            toggleBtt = false;
                          }
                        });
                      },
                      child: const Text('Show/Hide Saved IDs', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    color: Colors.green,
                    height: 30,
                    width: 150,
                    child: TextButton(
                      onPressed: () => exit(0),
                      child: const Text('Exit', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),

            if(toggleBtt) Container(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                border: TableBorder.all(),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: tableDisplay,
              ),
            )
          ],
        ),
      ),
    );
  }
}


//class for attributes and IDs
class AttributeIDs {
  String id = '';
  String attributeNo1 = '';
  String attributeNo2 = '';
  String attributeNo3 = '';
  String attributeNo4 = '';
  String attributeNo5 = '';
  String attributeNo6 = '';
  String attributeNo7 = '';
  String attributeNo8 = '';

  AttributeIDs(String newId, String newA1, String newA2, String newA3, String newA4, String newA5, String newA6, String newA7, String newA8) {
    id = newId;
    attributeNo1 = newA1;
    attributeNo2 = newA2;
    attributeNo3 = newA3;
    attributeNo4 = newA4;
    attributeNo5 = newA5;
    attributeNo6 = newA6;
    attributeNo7 = newA7;
    attributeNo8 = newA8;
  }

  String getIDs() {
    return id;
  }
  String getAtt1() {
    return attributeNo1;
  }
  String getAtt2() {
    return attributeNo2;
  }
  String getAtt3() {
    return attributeNo3;
  }
  String getAtt4() {
    return attributeNo4;
  }
  String getAtt5() {
    return attributeNo5;
  }
  String getAtt6() {
    return attributeNo6;
  }
  String getAtt7() {
    return attributeNo7;
  }
  String getAtt8() {
    return attributeNo8;
  }
  @override
  String toString() {
    return '[ID: $id, Att1: $attributeNo1, Att2: $attributeNo2, Att3: $attributeNo3, Att4: $attributeNo4, Att5: $attributeNo5, Att6: $attributeNo6, Att7: $attributeNo7, Att8: $attributeNo8]';
  }
}
