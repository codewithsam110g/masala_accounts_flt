import 'package:flutter/material.dart';
import 'package:masala_accounts/objects/account.dart';

class AddAccountModal extends StatefulWidget {
  const AddAccountModal({super.key});

  @override
  State<AddAccountModal> createState() => _AddAccountModalState();
}

class _AddAccountModalState extends State<AddAccountModal> {
  TextEditingController name = TextEditingController();
  TextEditingController amount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0) +
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Add an Account"),
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.name,
            controller: name,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Name:"),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.number,
            controller: amount,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), label: Text("Amount:")),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () async {
                    String na = name.text.toString();
                    double am = double.tryParse(amount.text.toString()) ?? 0.0;
                    await Account.createAccount(na, am);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Add")),
            ],
          ),
        ],
      ),
    );
  }
}
