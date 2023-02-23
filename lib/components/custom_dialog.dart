import 'package:flutter/material.dart';
import 'package:pdf_manager/components/images.dart';
import 'package:pdf_manager/components/navigation.dart';
import 'textfield.dart';

class DialogFb1 extends StatelessWidget {
  final TextEditingController? controller;
  final Function()? submit;
  const DialogFb1({this.controller, required this.submit});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: 222,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.1)),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 80,
              child: Image.asset(Images.img2pdf),
            ),
            //
            const SizedBox(
              height: 5,
            ),
            //
            const Text("Convert to PDF",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            //
            const SizedBox(
              height: 15,
            ),
            //
            CustomTextField(
              text: 'Give the file a name',
              validator: (String) {
                return "";
              },
              controller: controller!,
            ),
            //
            const SizedBox(
              height: 15,
            ),
            //
            Container(
                width: double.infinity, height: 1, color: Colors.grey[400]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.grey, minimumSize: Size(100, 40)),
                    onPressed: () {
                      pop();
                    },
                    child: Text('Cancel')),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.red, minimumSize: Size(100, 40)),
                    onPressed: submit,
                    child: Text('Confrim')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
