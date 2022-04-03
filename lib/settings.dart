import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/data_manager.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final textEditingController = TextEditingController();

  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context, listen: false);
    if (textEditingController.text.isEmpty && dataManager.rulesURL != null) {
      textEditingController.text = dataManager.rulesURL!;
    }
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
                  TextField(
                    controller: textEditingController,
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'https://link.to/rules.json',
                    ),
                    onSubmitted: (value) {
                      dataManager.rulesURL = textEditingController.text;
                      dataManager.reloadRules();
                    },
                  ),
                ],
              ),
              TableRow(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('${context.watch<DataManager>().rules.length} rules loaded'),
                      ),
                      TextButton(
                        child: const Text('Reload Rules'),
                        onPressed: () {
                          dataManager.reloadRules();
                        },
                      ),
                    ],
                  )
                ],
              ),
              ...List<TableRow>.generate(dataManager.rules.length, (index) {
                final rule = dataManager.rules[index];
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                rule.regexMatch ?? '*',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Regex: ${rule.regex}',
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          const Spacer(),
                          Text(rule.publishTopic),
                        ],
                      ),
                    ),
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
