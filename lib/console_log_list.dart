import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/data_manager.dart';
import 'settings.dart';

class ConsoleLogList extends StatefulWidget {
  const ConsoleLogList({Key? key}) : super(key: key);

  @override
  _ConsoleLogListState createState() => _ConsoleLogListState();
}

class _ConsoleLogListState extends State<ConsoleLogList> {
  DataManager dataManager(BuildContext context) {
    return context.watch<DataManager>();
  }

  void clearConsoleLog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Console Log?'),
          content: const Text('This action cannot be undone.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                dataManager(context).clearConsoleLogs();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notifications to MQTT'),
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Settings()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              clearConsoleLog(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text(
                '${dataManager(context).rules.length} rule${dataManager(context).rules.length == 1 ? '' : 's'} loaded'),
          ),
          const Divider(height: 1),
          SingleChildScrollView(
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              children: List<TableRow>.generate(dataManager(context).consoleOutput.length, (index) {
                final consoleOutput = dataManager(context).consoleOutput[index];
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child:
                                consoleOutput.icon != null ? Image.memory(consoleOutput.icon!) : const Icon(Icons.apps),
                          ),
                          Flexible(
                            child: Text(
                              "[${consoleOutput.timestamp.toString()}] " + consoleOutput.message,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
