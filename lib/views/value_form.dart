import 'dart:convert';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/material.dart';
import 'package:msg/models/proprety_value.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class ValueForm extends StatefulWidget {
  const ValueForm({Key? key}) : super(key: key);

  @override
  State<ValueForm> createState() => _ValueFormState();
}

class _ValueFormState extends State<ValueForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for textfields
  final _nameController = TextEditingController();
  final _areaController = TextEditingController();
  
  // Clears the controller when the widget is disposed.
  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  static ConnectionSettings settings = ConnectionSettings(
      host: "localhost",
      maxConnectionAttempts: 3
    );

  void sendMessage() async{
 
    final Client _client = Client(settings: settings);

      debugPrint("name:" + _nameController.text);
      debugPrint("area:" + _areaController.text);
      debugPrint("connecting..");

      _client
        .channel()
        .then((Channel channel) {
          return channel.queue("hello-world", durable: false);
        })
        .then((Queue queue) {
          queue.publish("hello world");
          _client.close();
        });
  }
  

  // Locally save order to users device
  void localSave() async {
    final instance = await SharedPreferences.getInstance();

    PropretyValue propretyValue =
        PropretyValue(_nameController.text, _areaController.text, 0);

    Map<String, dynamic> map = {
      'name': propretyValue.name,
      'area': propretyValue.area,
      'value': propretyValue.value
    };

    instance.setString(_nameController.text, jsonEncode(map));
    clearText();
  }

  void clearText() {
    _nameController.clear();
    _areaController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Center(
                child: Column(children: [
              const Padding(padding: EdgeInsets.only(top: 200.0)),
              buildTextFormField(_nameController, "Vnesi naziv naloga"),
              const Padding(padding: EdgeInsets.only(top: 30.0)),
              buildTextFormField(_areaController, "Vnesi površino"),
              const Padding(padding: EdgeInsets.only(top: 30.0)),
              buildElevatedButton("Pošlji")
            ]))));
  }

  Widget buildTextFormField(controller, labelText) {
    return TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vnesite podatke.';
          }
          return null;
        },
        decoration: buildInputDecoration(labelText),
        keyboardType: TextInputType.text);
  }

  InputDecoration buildInputDecoration(labelText) {
    return InputDecoration(
        labelText: labelText,
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide()));
  }

  Widget buildElevatedButton(labelText) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50), // NEW
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      child: Text(labelText, style: const TextStyle(fontSize: 20),),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          debugPrint('Value form fired');
          sendMessage();
          localSave();
        }
      },
    );
  }
}
