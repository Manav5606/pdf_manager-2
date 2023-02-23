import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Screens/Home/Home.dart';
import '../components/strings.dart';

class SubScriptions extends StatefulWidget {
  const SubScriptions({Key? key}) : super(key: key);

  @override
  State<SubScriptions> createState() => _SubScriptionsState();
}

class _SubScriptionsState extends State<SubScriptions> {
  int _selectedContainerIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   title: Text(AppString.appName, style: TextStyle(fontSize: 16)),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                  top: MediaQuery.of(context).size.height * 0.05,
                  left: MediaQuery.of(context).size.width * 0.05),
              child: Container(
                height: 50,
                width: double.infinity,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: Icon(
                        Icons.disabled_by_default_outlined,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              // color: Colors.redAccent,
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/sub_pdf.png",
                      height: 150,
                      width: 150,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Text(
                            'Unlimited Access',
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'To All Features',
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              // color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Edit or sign PDF      ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Convert to PDF         ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Print with AirPrint    ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "No ads and no limits",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.32,
              width: MediaQuery.of(context).size.width * 0.9,
              // color: Colors.redAccent,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: 2,
                        itemBuilder: (BuildContext context, int index) {
                          bool selected = _selectedContainerIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedContainerIndex = index;
                              });
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: MediaQuery.of(context).size.width * 0.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  // color: Colors.blue,
                                  border: Border.all(
                                    color: selected ? Colors.blue : Colors.grey,
                                    width: 2,
                                  )),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("3 Days Free          "),
                                      Text("    then 41.90 / month"),
                                    ],
                                  ),
                                  Expanded(
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 2,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text("41.90 / month  "),
                                          ],
                                        )),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     setState(() {
                  //       _selectedContainerIndex = 0;
                  //     });
                  //   },
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height * 0.08,
                  //     width: MediaQuery.of(context).size.width * 0.8,
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10.0),
                  //         // color: Colors.blue,
                  //         border: Border.all(
                  //           color: _selectedContainerIndex == 0
                  //               ? Colors.blue
                  //               : Colors.grey,
                  //           width: 2,
                  //         )),
                  //     child: Row(
                  //       children: [
                  //         Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Text("3 Days Free           "),
                  //             Text("    then 173.90 / month"),
                  //           ],
                  //         ),
                  //         Expanded(
                  //           child: Align(
                  //               alignment: Alignment.centerRight,
                  //               child: Row(
                  //                 mainAxisAlignment: MainAxisAlignment.end,
                  //                 children: [
                  //                   Container(
                  //                     height: 30,
                  //                     width: 2,
                  //                     color: Colors.grey,
                  //                   ),
                  //                   SizedBox(
                  //                     width: 15,
                  //                   ),
                  //                   Text("14.90 / month  "),
                  //                 ],
                  //               )),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  Container(
                    height: MediaQuery.of(context).size.height * 0.09,
                    width: MediaQuery.of(context).size.width * 0.82,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              // color: Colors.pinkAccent,
            ),
          ],
        ),
      ),
    );
  }
}
