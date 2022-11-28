import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'filter.dart';
import 'model/data_manager.dart';
import 'model/notification.dart' as DataModel;
import 'settings.dart';

class ConsoleLogList extends StatefulWidget {
  const ConsoleLogList({Key? key}) : super(key: key);

  @override
  _ConsoleLogListState createState() => _ConsoleLogListState();
}

class _ConsoleLogListState extends State<ConsoleLogList> {
  final dateFormat = DateFormat('EEE h:mm:ss a');

  void clearConsoleLog(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context, listen: false);
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
                dataManager.clearConsoleLogs();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void repeatNotification(BuildContext context, DataModel.Notification notification) {
    final dataManager = Provider.of<DataManager>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Repeat Notification?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                dataManager.processRemoteNotification(notification);
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
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Filter()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              clearConsoleLog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text('${dataManager.rules.length} rule${dataManager.rules.length == 1 ? '' : 's'} loaded'),
          ),
//          Padding(
//            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//            child: Text('${dataManager.consoleOutput.length} console output'),
//          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder.all(color: Colors.grey),
                children: List<TableRow>.generate(dataManager.filteredConsoleOutput.length, (index) {
                  final consoleOutput = dataManager.filteredConsoleOutput[index];
                  return TableRow(
                    children: [
                      TableRowInkWell(
                        onTap: consoleOutput.notification != null
                            ? () {
                                repeatNotification(context, consoleOutput.notification!);
                              }
                            : null,
                        child: Padding(
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
                                  '[${dateFormat.format(consoleOutput.timestamp)}] ${consoleOutput.message}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
