import 'package:flutter/material.dart';
import 'package:flutter_mini_pos/localization/localization.dart';
import 'package:form_field_validator/form_field_validator.dart';

class FormFieldWidget extends StatelessWidget {
  
  final TextEditingController textEditingController;
  String hint;
  FormFieldWidget({
    @required this.textEditingController,
    @required this.hint
  
  });
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: RequiredValidator(
          errorText:
          AppLocalizations.of(context).translate("error_form_entry")),
      controller: textEditingController,
      autofocus: false,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600], width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400], width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red[300], width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red[300], width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400])),
    );
  }
}
