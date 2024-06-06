import 'package:flutter/material.dart';
import 'api_service.dart';

class IniEditor {
  final Map<String, Map<String, String>> iniFileContents;
  final Function updateState;
  final String ipAddress;
  final String slot;

  IniEditor(this.iniFileContents, this.updateState, this.ipAddress, this.slot);

  Widget build(BuildContext context) {
    List<Widget> sections = [];
    iniFileContents.forEach((sectionName, entries) {
      sections.add(buildSection(context, sectionName, entries));
    });
    return Column(children: sections);
  }

  Widget buildSection(BuildContext context, String sectionName, Map<String, String> entries) {
  List<Widget> widgets = [];

  // Add each entry as a row in the section
  entries.forEach((key, value) {
    var tagValueController = TextEditingController(text: value);

    List<Widget> rowChildren = [
      Expanded(
        flex: 2,
        child: TextFormField(
          controller: TextEditingController(text: key),
          decoration: const InputDecoration(labelText: 'Name'),
          onFieldSubmitted: (newKey) {
            if (newKey != key) {
              var oldValue = entries.remove(key);
              entries[newKey] = oldValue ?? '';
              updateState();
            }
          },
        ),
      ),
      Expanded(
        flex: 3,
        child: TextFormField(
          controller: tagValueController,
          decoration: const InputDecoration(labelText: 'Value'),
          onFieldSubmitted: (newValue) {
            if (newValue != value) {
              entries[key] = newValue;
              updateState();
            }
          },
        ),
      ),
    ];

    // Add buttons only for 'plc-tags' section
    if (sectionName == 'plc-tags') {
      rowChildren.addAll([
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () => _showEditDialog(context, sectionName, key: key, originalController: tagValueController),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            entries.remove(key);
            updateState();
          },
        ),
      ]);
    }

    widgets.add(Row(children: rowChildren));
  });

  if (sectionName == 'plc-tags') {
    widgets.add(
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () => _showEditDialog(context, sectionName),
      )
    );
  }

  return ExpansionTile(
    title: Text(sectionName),
    children: widgets,
  );
}

void _showEditDialog(BuildContext context, String sectionName, {String? key, TextEditingController? originalController}) {
  bool isNewTag = key == null; // Determine if this is a new tag addition
  TextEditingController searchController = TextEditingController();
  ApiService apiService = ApiService();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(isNewTag ? "Add a New PLC Tag" : "Select PLC Tag for $key"),
        content: Container(
          height: 300, // Limit the height
          width: double.maxFinite, // Use maximum width
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    // Trigger UI update to reflect search results
                    (context as Element).markNeedsBuild();
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: apiService.fetchStoredPlcTags(ipAddress, slot),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      List<dynamic> filteredTags = snapshot.data!.where((tag) {
                        return tag['name'].toLowerCase().contains(searchController.text.toLowerCase());
                      }).toList();

                      return ListView.builder(
                        itemCount: filteredTags.length,
                        itemBuilder: (context, index) {
                          var tag = filteredTags[index];
                          return ListTile(
                            title: Text(tag['name']),
                            subtitle: Text(tag['datatype']),
                            onTap: () {
                              Navigator.of(context).pop();
                              if (isNewTag) {
                                // Add new tag directly with the same key and value
                                iniFileContents[sectionName]![tag['name']] = tag['name'];
                              } else {
                                // For existing tags, update the key-value pair
                                if (originalController != null && key != null) {
                                  originalController.text = tag['name'];
                                  iniFileContents[sectionName]![key] = tag['name'];
                                }
                              }
                              updateState();  // Update the state to refresh the UI
                            }
                          );
                        },
                      );
                    } else {
                      return Text("No data available");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}


}
