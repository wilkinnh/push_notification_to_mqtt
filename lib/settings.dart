import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/data_manager.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final mqttServerEditingController = TextEditingController();
  final rulesURLEditingController = TextEditingController();

  void dispose() {
    mqttServerEditingController.dispose();
    rulesURLEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context, listen: false);
    if (mqttServerEditingController.text.isEmpty && dataManager.mqttServerURL != null) {
      mqttServerEditingController.text = dataManager.mqttServerURL!;
    }
    if (rulesURLEditingController.text.isEmpty && dataManager.rulesURL != null) {
      rulesURLEditingController.text = dataManager.rulesURL!;
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
                    'MQTT Server',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: mqttServerEditingController,
                      keyboardType: TextInputType.url,
                      autocorrect: false,
                      enableSuggestions: false,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'MQTT URL',
                      ),
                      onSubmitted: (value) {
                        dataManager.mqttServerURL = mqttServerEditingController.text;
                      },
                    ),
                  ),
                ],
              ),
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
                    controller: rulesURLEditingController,
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'https://link.to/rules.json',
                    ),
                    onSubmitted: (value) {
                      dataManager.rulesURL = rulesURLEditingController.text;
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
                              ),
                              Text(
                                rule.packageName,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
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
