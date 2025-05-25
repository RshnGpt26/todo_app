import 'package:flutter/material.dart';

class AddTodoSheetWidget extends StatefulWidget {
  const AddTodoSheetWidget({
    super.key,
    required this.onSave,
    this.isUpdating,
    this.oldText,
  });

  final Future<void> Function(String title) onSave;
  final bool? isUpdating;
  final String? oldText;

  @override
  State<AddTodoSheetWidget> createState() => _AddTodoSheetWidgetState();
}

class _AddTodoSheetWidgetState extends State<AddTodoSheetWidget> {
  final TextEditingController _title = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isUpdating == true && (widget.oldText ?? "").isNotEmpty) {
      _title.text = widget.oldText ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.cancel),
                  iconSize: 30,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _title,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "TODO",
                  hintText:
                      widget.isUpdating == true
                          ? "Enter your changes..."
                          : "Enter your upcoming todo...",
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (MediaQuery.of(context).viewInsets.bottom > 0) {
                        FocusScope.of(context).unfocus();
                      }
                      if (_title.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter some text!!")),
                        );
                      } else {
                        await widget.onSave(_title.text);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text("Save"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
