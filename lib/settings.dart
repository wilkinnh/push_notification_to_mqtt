import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/data_manager.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void reloadRules(BuildContext context) {
    context.watch<DataManager>().reloadRules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Table(
          border: TableBorder.all(color: Colors.black),
          children: [
            TableRow(
              children: [
                const Text("Public path to rules JSON"),
                TextFormField(
                  initialValue: context.watch<DataManager>().rulesURL,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'https://link.to/rules.json',
                  ),
                  onSaved: (value) {
                    context.watch<DataManager>().rulesURL = value;
                    reloadRules(context);
                  },
                ),
              ],
            ),
            TableRow(children: [
              TextButton(
                child: const Text("Reload Rules"),
                onPressed: () {
                  reloadRules(context);
                },
              )
            ])
          ],
        ),
      ),
    );
  }
}
