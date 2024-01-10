import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class PhoneDialer extends StatefulWidget {
  const PhoneDialer({Key? key}) : super(key: key);

  @override
  _PhoneDialerState createState() => _PhoneDialerState();
}

class _PhoneDialerState extends State<PhoneDialer> {
  final TextEditingController _numberCtrl = TextEditingController();
  final List<String> _dialedNumbers = []; // List to store dialed numbers

  @override
  void initState() {
    super.initState();
    _numberCtrl.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade800,
          title: const Text('Phone dialer'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Builder(
            builder: (BuildContext context) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextField(
                        controller: _numberCtrl,
                        decoration:  InputDecoration(labelText: " Enter Phone Number",labelStyle: TextStyle(
                            color: Colors.deepPurple.shade800,
                            fontWeight: FontWeight.w500
                        )),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple.shade800
                      ),
                      child: const Text(" Call"),
                      onPressed: () async {
                        if (_numberCtrl.text.isEmpty) {
                          const snackBar = SnackBar(content: Text('Please enter a phone number',style: TextStyle(
                              color: Colors.white
                          ),),backgroundColor:   Colors.deepPurple,elevation: 8);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          FlutterPhoneDirectCaller.callNumber(_numberCtrl.text);
                          setState(() {
                            _dialedNumbers.add(_numberCtrl.text); // Add dialed number to the list
                          });
                          _numberCtrl.text = "";
                        }
                      },
                    ),
                    const SizedBox(height: 20,),
                    ..._dialedNumbers.map((number) => Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Card(
                        elevation: 6,
                        shadowColor: Colors.deepPurple.shade800,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.call_made,color: Colors.green),
                              const SizedBox(width: 30,),
                              Text( number,style: TextStyle(
                                  color: Colors.deepPurple.shade800,
                                  fontWeight: FontWeight.bold
                              ),),
                            ],
                          ),
                        ),
                      ),
                    )).toList(), // Display dialed numbers
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
