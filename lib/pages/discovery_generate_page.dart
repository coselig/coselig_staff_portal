import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coselig_staff_portal/widgets/theme_toggle_switch.dart';

class Device {
  String brand;
  String model;
  String type;
  String moduleId;
  String channel;
  String name;
  String tcp;

  Device({
    required this.brand,
    required this.model,
    required this.type,
    required this.moduleId,
    required this.channel,
    required this.name,
    required this.tcp,
  });

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'model': model,
      'type': type,
      'module_id': moduleId,
      'channel': channel,
      'name': name,
      'tcp': tcp,
    };
  }
}

class DiscoveryGeneratePage extends StatefulWidget {
  const DiscoveryGeneratePage({super.key});

  @override
  State<DiscoveryGeneratePage> createState() => _DiscoveryGeneratePageState();
}

class _DiscoveryGeneratePageState extends State<DiscoveryGeneratePage> {
  final List<Device> devices = [];
  List<String> get brands => deviceConfigs.keys.toList();
  Map<String, List<String>> get models => deviceConfigs.map(
    (brand, modelsMap) => MapEntry(brand, modelsMap.keys.toList()),
  );

  // Combined map for device configurations: brand -> model -> {'types': [...], 'channels': {type: [...]}}
  final Map<String, Map<String, Map<String, dynamic>>> deviceConfigs = {
    'sunwave': {
      'p404': {
        'types': ['dual', 'single', 'wrgb', 'rgb'],
        'channels': {
          'dual': ['a', 'b'],
          'single': ['1', '2', '3', '4'],
          'wrgb': ['x'],
          'rgb': ['x'],
        },
      },
      'p210': {
        'types': ['dual', 'single'],
        'channels': {
          'dual': ['a'],
          'single': ['1', '2'],
        },
      },
      'U4': {
        'types': ['dual', 'single', 'wrgb', 'rgb'],
        'channels': {
          'dual': ['a', 'b'],
          'single': ['1', '2', '3', '4'],
          'wrgb': ['x'],
          'rgb': ['x'],
        },
      },
      'R8A': {
        'types': ['relay'],
        'channels': {
          'relay': ['1', '2', '3', '4', '5', '6', '7', '8'],
        },
      },
      'R410': {
        'types': ['relay'],
        'channels': {
          'relay': ['1', '2', '3', '4'],
        },
      },
    },
    'guo': {
      'p805': {
        'types': ['dual', 'single'],
        'channels': {},
      },
    },
  };

  String selectedBrand = 'sunwave';
  String selectedModel = 'p404';
  String selectedType = 'single';
  String selectedChannel = '1';
  final TextEditingController moduleIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController tcpController = TextEditingController();
  String generatedOutput = '';

  List<String> getAvailableChannels(String brand, String model, String type) {
    final channelsMap =
        deviceConfigs[brand]?[model]?['channels'] as Map<String, List<String>>;
    return channelsMap[type] ?? ['1'];
  }

  List<String> getAvailableTypes(String brand, String model) {
    return deviceConfigs[brand]?[model]?['types'] as List<String>;
  }

  void addDevice() {
    if (moduleIdController.text.isNotEmpty &&
        nameController.text.isNotEmpty) {
      setState(() {
        devices.add(Device(
          brand: selectedBrand,
          model: selectedModel,
          type: selectedType,
          moduleId: moduleIdController.text,
          channel: selectedChannel,
          name: nameController.text,
            tcp: tcpController.text,
        ));
        moduleIdController.clear();
        nameController.clear();
        tcpController.clear();
      });
    }
  }

  void removeDevice(int index) {
    setState(() {
      devices.removeAt(index);
    });
  }

  void generateOutput() {
    StringBuffer buffer = StringBuffer();
    buffer.writeln('msg.devices = [');
    for (int i = 0; i < devices.length; i++) {
      var device = devices[i];
      buffer.write(
        '    { brand: "${device.brand}", model: "${device.model}", type: "${device.type}", module_id: "${device.moduleId}", channel: "${device.channel}", name: "${device.name}", tcp: "${device.tcp}" }',
      );
      if (i < devices.length - 1) {
        buffer.writeln(',');
      } else {
        buffer.writeln();
      }
    }
    buffer.writeln('];');
    buffer.writeln('return msg;');
    setState(() {
      generatedOutput = buffer.toString();
    });
  }

  void copyToClipboard() async {
    if (generatedOutput.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: generatedOutput));
      // 使用 ScaffoldMessenger 顯示成功訊息
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('輸出內容已複製到剪貼簿')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('裝置註冊表生成器'),
        actions: const [ThemeToggleSwitch()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add Device Form
            Row(
              children: [
                // Brand
                Expanded(
                  flex: 1,
                  child: DropdownButton<String>(
                    value: selectedBrand,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBrand = newValue!;
                        selectedModel = models[selectedBrand]!.first;
                        List<String> availableTypes = getAvailableTypes(selectedBrand, selectedModel);
                        if (!availableTypes.contains(selectedType)) {
                          selectedType = availableTypes.first;
                        }
                        selectedChannel = getAvailableChannels(selectedBrand, selectedModel, selectedType).first;
                      });
                    },
                    items: brands.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                // Model
                Expanded(
                  flex: 1,
                  child: DropdownButton<String>(
                    value: selectedModel,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedModel = newValue!;
                        List<String> availableTypes = getAvailableTypes(selectedBrand, selectedModel);
                        if (!availableTypes.contains(selectedType)) {
                          selectedType = availableTypes.first;
                        }
                        selectedChannel = getAvailableChannels(selectedBrand, selectedModel, selectedType).first;
                      });
                    },
                    items: models[selectedBrand]!.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                // Type
                Expanded(
                  flex: 1,
                  child: DropdownButton<String>(
                    value: selectedType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedType = newValue!;
                        selectedChannel = getAvailableChannels(selectedBrand, selectedModel, selectedType).first;
                      });
                    },
                    items: getAvailableTypes(selectedBrand, selectedModel).map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                // Module ID
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: moduleIdController,
                    decoration: const InputDecoration(labelText: 'Module ID'),
                  ),
                ),
                const SizedBox(width: 8),
                // Channel
                Expanded(
                  flex: 1,
                  child: DropdownButton<String>(
                    value: selectedChannel,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedChannel = newValue!;
                      });
                    },
                    items: getAvailableChannels(selectedBrand, selectedModel, selectedType)
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                // Name
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                ),
                const SizedBox(width: 8),
                // TCP
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: tcpController,
                    decoration: const InputDecoration(labelText: 'TCP'),
                  ),
                ),
                const SizedBox(width: 8),
                // Add Button
                ElevatedButton(
                  onPressed: addDevice,
                  child: const Text('添加'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Device List
            Expanded(
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  var device = devices[index];
                  return ListTile(
                    title: Text('${device.brand} ${device.model} - ${device.type} - ${device.name}'),
                    subtitle: Text('Module: ${device.moduleId}, Channel: ${device.channel}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => removeDevice(index),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Buttons Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: generateOutput,
                    child: const Text('生成輸出'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: copyToClipboard,
                    icon: const Icon(Icons.copy),
                    label: const Text('複製輸出'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Output Display
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  generatedOutput,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
