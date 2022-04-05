import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/data_manager.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _mqttServerEditingController = TextEditingController();
  final _mqttUsernameController = TextEditingController();
  final _mqttPasswordController = TextEditingController();
  final _rulesURLEditingController = TextEditingController();

  void _initializeControllers(DataManager dataManager) {
    if (_mqttServerEditingController.text.isEmpty && dataManager.mqttServerURL != null) {
      _mqttServerEditingController.text = dataManager.mqttServerURL!;
    }
    if (_mqttUsernameController.text.isEmpty && dataManager.mqttUsername != null) {
      _mqttUsernameController.text = dataManager.mqttUsername!;
    }
    if (_mqttPasswordController.text.isEmpty && dataManager.mqttPassword != null) {
      _mqttPasswordController.text = dataManager.mqttPassword!;
    }
    if (_rulesURLEditingController.text.isEmpty && dataManager.rulesURL != null) {
      _rulesURLEditingController.text = dataManager.rulesURL!;
    }
  }

  void dispose() {
    _mqttServerEditingController.dispose();
    _mqttUsernameController.dispose();
    _mqttPasswordController.dispose();
    _rulesURLEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context, listen: false);
    _initializeControllers(dataManager);
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
                  TextField(
                    controller: _mqttServerEditingController,
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'MQTT URL',
                    ),
                    onSubmitted: (value) {
                      dataManager.mqttServerURL = _mqttServerEditingController.text;
                    },
                  ),
                ],
              ),
              TableRow(
                children: [
                  TextField(
                    controller: _mqttUsernameController,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'MQTT username',
                    ),
                    onSubmitted: (value) {
                      dataManager.mqttUsername = _mqttUsernameController.text;
                    },
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: _mqttPasswordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'MQTT password',
                      ),
                      onSubmitted: (value) {
                        dataManager.mqttPassword = _mqttPasswordController.text;
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
                    controller: _rulesURLEditingController,
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    enableSuggestions: false,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'https://link.to/rules.json',
                    ),
                    onSubmitted: (value) {
                      dataManager.rulesURL = _rulesURLEditingController.text;
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
                                rule.publishTopic,
                                style: const TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                              Text(
                                rule.packageName,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Title regex: ${rule.titleRegex ?? '*'}',
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Message regex: ${rule.messageRegex ?? '*'}',
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              if (rule.dataTemplate != null)
                                Text(
                                  'Data template: ${rule.dataTemplate!}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                          const Spacer(),
                          Column(
                            children: [],
                          ),
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
