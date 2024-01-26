import 'package:flutter/material.dart';
import 'package:flutter_application_qubby/AppStyles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dialog Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Dialog Example'),
        ),
        body: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String objectName = '';
  String objectType = '';

  void _showCreateObjectDialog() async {
    final result = await showDialog<CreateObjectResult>(
      context: context,
      builder: (BuildContext context) => const CreateObjectDialog(),
    );

    if (result != null) {
      setState(() {
        objectName = result.name;
        objectType = result.type;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: _showCreateObjectDialog,
            child: const Text('Create Object'),
          ),
          const SizedBox(height: 6.0),
          Text('Object Name: $objectName'),
          const SizedBox(height: 6.0),
          Text('Object Type: $objectType'),
        ],
      ),
    );
  }
}

class CreateObjectDialog extends StatefulWidget {
  const CreateObjectDialog({Key? key}) : super(key: key);

  @override
  CreateObjectDialogState createState() => CreateObjectDialogState();
}

class CreateObjectDialogState extends State<CreateObjectDialog> {
  final _objectNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedType;
  final List<String> _objectTypes = ['Type 1', 'Type 2', 'Type 3'];
  bool _isCreateButtonEnabled = false;

  @override
  void dispose() {
    _objectNameController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_isCreateButtonEnabled) {
      if (_formKey.currentState?.validate() ?? false) {
        Navigator.of(context).pop(CreateObjectResult(
          _objectNameController.text,
          _selectedType!,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
            width: AppStyles.dialogWidth,
            height: AppStyles.dialogHeight,
            padding: const EdgeInsets.all(12.0),
            child: Stack(children: <Widget>[
              _buildIcon(context),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 26.0,
                    top: 12.0,
                    right: 26.0,
                    bottom: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _buildTitle(),
                      const Text(
                        "物件名稱",
                        style: AppStyles.normalTextStyle,
                      ),
                      const SizedBox(height: 6.0),
                      buildTextField(_objectNameController, '物件名稱', (value) {
                        setState(() {
                          _isCreateButtonEnabled = value.isNotEmpty;
                        });
                      }),
                      const Spacer(),
                      const Text(
                        "物件類型",
                        style: AppStyles.normalTextStyle,
                      ),
                      const SizedBox(height: 6.0),
                      ObjectTypeDropdown(
                        objectTypes: _objectTypes,
                        onSelectedTypeChanged: (newValue) =>
                            setState(() => _selectedType = newValue),
                      ),
                      const Spacer(),
                      _buildCreateButton(),
                    ],
                  ),
                ),
              ),
            ])));
  }

  Widget _buildCreateButton() {
    return Center(
      child: ElevatedButton(
        style: AppStyles.elevatedButtonStyle,
        onPressed: _isCreateButtonEnabled ? _handleSubmit : null,
        child: const Text(
          '創建',
          style: TextStyle(
            fontSize: AppStyles.fontSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

Widget _buildIcon(BuildContext context) {
  return Align(
    alignment: Alignment.topRight,
    child: IconButton(
      icon: const Icon(Icons.close),
      onPressed: () => Navigator.of(context).pop(),
    ),
  );
}

Widget _buildTitle() {
  return const Align(
    alignment: Alignment.center,
    child: Padding(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Text(
        '建立物件',
        style: AppStyles.titleTextStyle,
      ),
    ),
  );
}

Widget buildTextField(TextEditingController controller, String hintText,
    Function(String) onChanged) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      border: const OutlineInputBorder(),
    ),
    onChanged: onChanged,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '必填欄位';
      }
      return null;
    },
  );
}

class CreateObjectResult {
  final String name;
  final String type;

  CreateObjectResult(this.name, this.type);
}

class ObjectTypeDropdown extends StatelessWidget {
  final List<String> objectTypes;
  final ValueChanged<String?> onSelectedTypeChanged;

  const ObjectTypeDropdown({
    Key? key,
    required this.objectTypes,
    required this.onSelectedTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        hintText: '選擇',
        border: OutlineInputBorder(),
      ),
      items: objectTypes.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onSelectedTypeChanged,
      validator: (value) => value == null || value.isEmpty ? '必填欄位' : null,
    );
  }
}
