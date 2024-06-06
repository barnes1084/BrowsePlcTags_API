import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'api_service.dart';
import 'ini_editor.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>(); 
  late FToast fToast;
  IniEditor? iniEditor;
  List<String> iniFiles = [];
  String? selectedIniFile;
  Map<String, Map<String, String>> iniFileContents = {};
  bool _isLoading = false;
  String _ipAddress = '';
  String _slot = '';

  @override
  void initState() {
    super.initState();
    iniEditor = IniEditor(iniFileContents, () => setState(() {}), _ipAddress, _slot);
    _fetchIniFileNames();
  }

  void _fetchIniFileNames() async { 
    setState(() { _isLoading = true; });
    try {
      iniFiles = (await ApiService().fetchIniFileNames('C:/Log')).cast<String>();
      _showToast('ini files loaded successfully.'); 
      setState(() { _isLoading = false; });
    } catch (e) {
      _showToast('Failed to load INI files: $e'); 
      setState(() { _isLoading = false; });
    }
  }

  void _fetchIniFileContents(String filePath) async { 
    setState(() { _isLoading = true; });
    try {
      var contents = await ApiService().fetchIniFileContents(filePath);
      iniFileContents = contents.map<String, Map<String, String>>(
        (key, value) => MapEntry(
          key,
          Map<String, String>.from(value.map((innerKey, innerValue) => MapEntry(innerKey, innerValue as String))),
        ),
      );
      _ipAddress = iniFileContents['plc']?['Ip'] ?? '';
      _slot = iniFileContents['plc']?['Slot'] ?? '';
      iniEditor = IniEditor(iniFileContents, () => setState(() {}), _ipAddress, _slot);
      _showToast('$filePath contents retrieved.'); 

      List<dynamic> tags = await ApiService().fetchStoredPlcTags(_ipAddress, _slot);
      if (tags.isEmpty) {
        // No tags found, prompt the user.
        _promptToUpdateTags();
      } 
      setState(() { _isLoading = false; });
    } catch (e) {
      _showToast('Failed to load INI file contents: $e'); 
      setState(() { _isLoading = false; });
    }
  }



void _promptToUpdateTags() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Update Tag List"),
        content: Text("No tags found for IP $_ipAddress and Slot $_slot. Do you want to update the tag list?"),
        actions: <Widget>[
          TextButton(
            child: Text("Yes"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _fetchPlcTags();
            },
          ),
          TextButton(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}

  void _fetchPlcTags() async { 
    if (_ipAddress.isEmpty || _slot.isEmpty) {
      _showToast('IP Address or Slot is missing.'); 
      return;
    }
    setState(() { _isLoading = true; });
    try {
      _showToast('calling GetTags API...'); 
      var tags = await ApiService().fetchPlcTags(_ipAddress, _slot);
      _showToast('Loaded ${tags.length} PLC tags successfully.'); 
    } catch (e) {
      _showToast('Failed to load PLC tags: $e'); 
    } finally {
      _fetchIniFileContents(selectedIniFile!);
      setState(() { _isLoading = false; });
    }
  }

  void _updateIniFile() async { 
    if (selectedIniFile == null) {
      _showToast('No INI file selected.'); 
      return;
    }
    setState(() { _isLoading = true; });
    try {
      await ApiService().updateIniFile(selectedIniFile!, iniFileContents);
      _showToast('INI file updated successfully.'); 
    } catch (e) {
      _showToast('Failed to update INI file: $e'); 
    } finally {
      _fetchIniFileContents(selectedIniFile!); 
      setState(() { _isLoading = false; });  
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3
      // webBgColor: Color.fromARGB(255, 57, 107, 139),
      // textColor: Colors.white,
      // fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          key: _scaffoldKey, 
          appBar: AppBar(
          title: const Text('INI File Editor'),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  DropdownButton<String>(
                    value: selectedIniFile,
                    hint: const Text("Select a file"),
                    icon: const Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedIniFile = newValue;
                      });
                    },
                    items: iniFiles.isNotEmpty ? iniFiles.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: 'C:/Log/$value',
                        child: Text(value),
                      );
                    }).toList() : [],
                  ),
                  ElevatedButton(
                    onPressed: selectedIniFile != null ? () => _fetchIniFileContents(selectedIniFile!) : null,
                    child: const Text('Load INI File'),
                  ),
                  Expanded(
                    child: ListView(
                      children: iniFileContents.entries.map((e) => iniEditor!.buildSection(context, e.key, e.value)).toList(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: selectedIniFile != null ? () => _updateIniFile() : null,
                    child: const Text('Update INI File'),
                  ),
                ],
              ),
      );
  }
}