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
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Table(
            children: [
              const TableRow(
                children: [
                  Text(
                    'Public path to rules JSON',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TextFormField(
                    initialValue: context.watch<DataManager>().rulesURL,
                    keyboardType: TextInputType.url,
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
                Row(
                  children: [
                    Expanded(
                      child: Text('${context.watch<DataManager>().rules.length} rules loaded'),
                    ),
                    TextButton(
                      child: const Text('Reload Rules'),
                      onPressed: () {
                        reloadRules(context);
                      },
                    ),
                  ],
                )
              ])
            ],
          ),
        ),
      ),
    );
  }
}
