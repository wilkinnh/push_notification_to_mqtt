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
  void clearConsoleLog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final dataManager = Provider.of<DataManager>(context);
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
                dataManager.clearConsoleLogs();
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
    final dataManager = Provider.of<DataManager>(context);
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
            child: Text('${dataManager.rules.length} rule${dataManager.rules.length == 1 ? '' : 's'} loaded'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text('${dataManager.consoleOutput.length} console output'),
          ),
          const Divider(height: 1),
          SingleChildScrollView(
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              children: List<TableRow>.generate(dataManager.consoleOutput.length, (index) {
                final consoleOutput = dataManager.consoleOutput[index];
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: consoleOutput.icon != null
                                ? Image.memory(
                                    consoleOutput.icon!,
                                    width: 44,
                                    height: 44,
                                  )
                                : const Icon(Icons.apps, size: 20),
                          ),
                          Flexible(
                            child: Text(
                              '[${consoleOutput.timestamp.toString()}] ${consoleOutput.message}',
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
