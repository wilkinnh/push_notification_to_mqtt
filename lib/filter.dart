import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/data_manager.dart';

class Filter extends StatelessWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context);
    final apps = dataManager.receivedNotificationApplications();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Table(
            children: [
              ...List<TableRow>.generate(apps.length, (index) {
                final app = apps[index];
                return TableRow(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.memory(
                            app.icon,
                            width: 44,
                            height: 44,
                          ),
                        ),
                        Expanded(
                          child: Text(app.appName),
                        ),
                        Switch(
                          value: dataManager.consoleOutputPackageNameFilter.any((filter) => filter == app.packageName),
                          onChanged: (_) {
                            dataManager.toggleConsoleOutputForApp(app.packageName);
                          },
                        ),
                      ],
                    )
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
