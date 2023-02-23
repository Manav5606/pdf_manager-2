import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_compressor/pdf_compressor.dart';
import 'package:pdf_manager/Controller/Tools.dart';
import 'package:pdf_manager/Screens/Home/Home.dart';
import 'package:pdf_manager/components/navigation.dart';
import 'package:pdf_manager/components/strings.dart';
import 'package:pdf_manager/components/text.dart';
import 'package:pdf_manager/components/style.dart';
import 'package:pdf_manager/screens/image_editor/success_screen.dart';
import 'dart:typed_data';

class CompressPDF extends StatefulWidget {
  final File file;
  const CompressPDF({required this.file});
  @override
  State<CompressPDF> createState() => _CompressPDFState();
}

class _CompressPDFState extends State<CompressPDF> {
  int radioValue = 1;
  CompressQuality quality = CompressQuality.MEDIUM;
  void handleRadioValueChanged(Object? value) {
    setState(() {
      radioValue = int.parse(value.toString());
      if (radioValue == 0) {
        setState(() {
          quality = CompressQuality.LOW;
        });
      } else if (radioValue == 1) {
        setState(() {
          quality = CompressQuality.MEDIUM;
        });
      } else if (radioValue == 2) {
        setState(() {
          quality = CompressQuality.HIGH;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Compress to PDF',
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: decoration,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/pdf.png',
                      width: 25,
                      height: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),

                    //
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.file.path.split('/').last,
                            style: TextStyle(color: textColor),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          FutureBuilder(
                            future: widget.file.stat(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data == null) return Container();
                              FileStat details = snapshot.data;
                              return Text(
                                getFileSize(widget.file).toString() +
                                    " " +
                                    "MB" +
                                    "  •  " +
                                    details.modified
                                        .toIso8601String()
                                        .split('T')
                                        .first,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.blueGrey),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    //
                  ],
                ),
              ),
              //
              SizedBox(height: 30),

              //
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(text: '-----------------------'),
                  CustomText(
                    text: 'COMPRESS QUALITY',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomText(text: '-----------------------'),
                ],
              ),

              //
              SizedBox(height: 30),

              CustomRadio(
                value: 0,
                text: 'HIGH',
                groupValue: radioValue,
                onChanged: handleRadioValueChanged,
              ),

              //
              SizedBox(height: 10),

              //
              CustomRadio(
                value: 1,
                text: 'MEDIUM',
                groupValue: radioValue,
                onChanged: handleRadioValueChanged,
              ),

              //
              SizedBox(height: 10),

              //
              CustomRadio(
                value: 2,
                text: 'LOW',
                groupValue: radioValue,
                onChanged: handleRadioValueChanged,
              ),

              // COMPRESS BUTTON
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      await PDFTools.compressor(
                              quality: quality, file: widget.file)
                          .then((value) =>
                              pushReplacement(SuccessScreen(path: value)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.symmetric(vertical: 20),
                      padding:
                          EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                      child: CustomText(
                        color: Colors.white,
                        text: 'START COMPRESS',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ))
            ],
          ),
        ));
  }

  double getFileSize(File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb.toPrecision(2);
  }
}

class CustomRadio extends StatefulWidget {
  final Function(Object?)? onChanged;
  final String text;
  final Object value;
  final Object groupValue;
  const CustomRadio(
      {required this.text,
      required this.value,
      required this.groupValue,
      required this.onChanged});

  @override
  State<CustomRadio> createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: RadioListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: Colors.grey[200],
        controlAffinity: ListTileControlAffinity.trailing,
        title: CustomText(
          text: widget.text,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        value: widget.value,
        groupValue: widget.groupValue,
        onChanged: widget.onChanged,
      ),
    );
  }
}
