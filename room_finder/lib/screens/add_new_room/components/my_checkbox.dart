import 'package:flutter/material.dart';
class MyCheckBox extends StatefulWidget {
  bool  checkBoxVal ;
  final String checkBoxTitle;
  final Function(bool) onChanged;
   MyCheckBox({Key? key, required this.checkBoxVal, required this.checkBoxTitle, required this.onChanged}) : super(key: key);

  @override
  State<MyCheckBox> createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: Text(widget.checkBoxTitle,overflow:TextOverflow.visible,),),

        Checkbox(value: widget.checkBoxVal, onChanged: (value){
          setState(() {
            widget.checkBoxVal = value!;
            widget.onChanged(value);
          });
        }),

      ],
    );
  }
}
