import 'package:flutter/material.dart';

class CustomTextFiled extends StatelessWidget {
  final String hintText;
  final IconData icons;
  final TextInputType inputType;
  final bool obscure;
  final FocusNode focusNode;
  final Function() onEditCom;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  Widget? widget;
  int? numberOfLines;
  CustomTextFiled({
    Key? key,
    required this.hintText,
    required this.icons,
    required this.inputType,
    required this.obscure,
    this.widget,
    this.numberOfLines,
    required this.focusNode,required this.onEditCom,required this.validator,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        onEditingComplete:onEditCom ,
        textInputAction: TextInputAction.done,
        obscureText: obscure,
        validator: validator,
        keyboardType: inputType,
        maxLines: numberOfLines??1,
        decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.grey.shade200,
            focusedBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:const  BorderSide(
                    width: 0.0,
                    color: Colors.white
                )),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    width: 0.0,
                    color: Colors.white
                ),
                borderRadius: BorderRadius.circular(10)
            ),
            suffixIcon: widget,
            prefixIcon:  Icon(icons,
              color: Colors.deepOrange,)
        ),
      ),
    );
  }
}


class InputField extends StatelessWidget {
  const InputField({Key? key,required this.title,required this.hint, this.controller, this.widget}) : super(key: key);
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16,),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 25
          ),),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              //padding: const EdgeInsets.symmetric(horizontal: 14),
              height: 52,
              width:double.infinity,
              decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.deepOrange
                  )

              ),
              child:Row(
                children: [
                  Expanded(child: TextFormField(
                    controller: controller,
                    readOnly: widget!=null?true:false,
                    autofocus: false,
                    cursorColor: Colors.grey[700],
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 25
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepOrange,
                            width: 0.0,
                          )
                      ),
                      hintStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 25
                      ),
                      enabledBorder: const  OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepOrange,
                            width: 0.0,
                          )
                      ),
                    ),
                  )),
                  widget??Container()
                ],
              )
          ),
        ],
      ),
    );
  }
}
