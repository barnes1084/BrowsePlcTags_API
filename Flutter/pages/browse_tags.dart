// import 'package:flutter/material.dart';
// import 'api_service.dart';
// import 'package:csv/csv.dart';
// import 'saveCsvToFile.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
//   final TextEditingController ipController = TextEditingController();
//   final TextEditingController slotController = TextEditingController();
//   List<dynamic> tags = [];
//   List<bool> selectedTags = []; // This will keep track of which tags are selected
//   bool _isLoading = false; // This will be used to show a loading indicator

//   String prepareCsvData() {
//     List<List<dynamic>> rows = [['TagName', 'DataType', 'Selected']];  // Header
//     for (int i = 0; i < tags.length; i++) {
//       if (selectedTags[i]) {  // Include only selected tags
//         rows.add([tags[i]['tagname'], tags[i]['datatype'], 'Yes']);
//       }
//     }
//     String csv = const ListToCsvConverter().convert(rows);
//     return csv;
//   }

//   void _fetchData() async {
//     setState(() {
//       _isLoading = true;  // Start loading
//     });
//     try {
//       var ipAddress = ipController.text;
//       var slot = int.tryParse(slotController.text) ?? 0;
//       var fetchedTags = await ApiService().fetchTagData(ipAddress, slot);
//       setState(() {
//         tags = fetchedTags;
//         selectedTags = List<bool>.filled(tags.length, false);
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;  // Stop loading
//       });
//     }
//   }

//   void _showSnackBar(String message) {
//     _scaffoldKey.currentState?.showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   void _exportData() async {
//     _showSnackBar('Exporting data...');
//     try {
//       String csvData = prepareCsvData();
//       await saveCsvToFile(csvData);
//       _showSnackBar('Data exported to CSV successfully.');
//     } catch (e) {
//       _showSnackBar('Failed to export data: $e');
//     }
//   }

// @override
// Widget build(BuildContext context) {
//   return MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: Text('Browse PLC Tags'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: TextField(
//                     controller: ipController,
//                     decoration: const InputDecoration(
//                       labelText: 'IP Address',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 Expanded(
//                   flex: 2,
//                   child: TextField(
//                     controller: slotController,
//                     decoration: const InputDecoration(
//                       labelText: 'Slot',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: _fetchData,
//                   child: Text('Fetch Data'),
//                 ),
//                 SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: _exportData,
//                   child: Text('Export to CSV'),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: _isLoading
//                 ? Center(child: CircularProgressIndicator())  // Show loading indicator
//                 : ListView.builder(
//                     itemCount: tags.length,
//                     itemBuilder: (context, index) {
//                       return buildRow(index);  // buildRow is your method to build each row
//                     },
//                   ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Widget buildRow(int index) {
//   return Container(
//     decoration: BoxDecoration(
//       border: Border(bottom: BorderSide(color: Colors.grey.shade300))
//     ),
//     child: IntrinsicHeight(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           Expanded(
//             flex: 3,
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//               child: Text(tags[index]['tagname']),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//               child: Text(tags[index]['datatype']),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Center(
//               child: Checkbox(
//                 value: selectedTags[index],
//                 onChanged: (bool? value) {
//                   if (value != null) {
//                     setState(() {
//                       selectedTags[index] = value;
//                     });
//                   }
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// }