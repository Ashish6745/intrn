import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LeadsList(),
    );
  }
}

class LeadsList extends StatefulWidget {
  @override
  _LeadsListState createState() => _LeadsListState();
}
class _LeadsListState extends State<LeadsList> {
  List<dynamic> leads = [];
  String filterText = '';


  @override
  void initState() {
    super.initState();
    getLeads();
  }



  void getLeads() async {
    var url = Uri.parse('https://api.thenotary.app/lead/getLeads');
    var headers = {"Content-Type": "application/json"};
    var body = jsonEncode({"notaryId": "643074200605c500112e0902"});

    try {
      var response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          leads = responseData['leads'];
        });

      } else {
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API DATA'),
        backgroundColor: Colors.deepPurple.shade800,
      ),
      body:  Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                filterText = value;
              });
            },
            decoration: const InputDecoration(
              hintText: 'Filter by First Name',
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: leads
                  .where((lead) => lead['firstName']
                  .toString()
                  .toLowerCase()
                  .contains(filterText.toLowerCase()))
                  .length,
              itemBuilder: (context, index) {
                var filteredLeads = leads
                    .where((lead) => lead['firstName']
                    .toString()
                    .toLowerCase()
                    .contains(filterText.toLowerCase()))
                    .toList();
                return ListTile(
                  tileColor: Colors.deepPurple,
                  title: Text(
                    '${filteredLeads[index]['firstName']}' +
                        " " +
                        '${filteredLeads[index]['lastName']}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Text(
                    filteredLeads[index]['email'],
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),

        ],
      ) ,
    );
  }
}
