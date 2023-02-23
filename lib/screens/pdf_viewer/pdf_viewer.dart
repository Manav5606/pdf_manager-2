import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:typed_data';
class CustomPDFViewer extends StatefulWidget {
  final File file;
  const CustomPDFViewer({required this.file});

  @override
  State<CustomPDFViewer> createState() => _CustomPDFViewerState();
}

class _CustomPDFViewerState extends State<CustomPDFViewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late TextEditingController pageNumber = TextEditingController();
  PdfViewerController controller = PdfViewerController();
  PdfPageLayoutMode pageLayoutMode = PdfPageLayoutMode.continuous;
  PdfScrollDirection scrollDirection = PdfScrollDirection.vertical;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color textColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('View PDF'),
        iconTheme: IconThemeData(color: textColor),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 5, 10, 5),
            color: Color.fromARGB(214, 36, 35, 35),
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...pageCounter(),
                ...pageNavigation(),
                Spacer(),
                settings()
              ],
            ),
          ),
          Expanded(
            child: SfPdfViewer.file(
              widget.file,
              key: _pdfViewerKey,
              pageLayoutMode: pageLayoutMode,
              scrollDirection: scrollDirection,
              controller: controller,
              onDocumentLoaded: (pageDetails) {
                setState(() {
                  pageNumber.text = controller.pageNumber.toString();
                });
              },
            ),
          )
        ],
      ),
    );
  }

  List<Widget> pageCounter() {
    return [
      Container(
          width: 30,
          child: TextField(
            keyboardType: TextInputType.number,
            onSubmitted: (value) {
              setState(() {
                if (value.isEmpty) {
                  pageNumber.text = "${controller.pageCount}";
                } else if (int.parse(value) > controller.pageCount) {
                  controller.jumpToPage(controller.pageCount);
                  pageNumber.text = "${controller.pageCount}";
                } else if (int.parse(value) <= 0) {
                  controller.jumpToPage(0);
                  pageNumber.text = "0";
                } else {
                  controller.jumpToPage(int.parse(value));
                }
              });
            },
            style: TextStyle(color: textColor),
            controller: pageNumber,
            decoration: InputDecoration(
              isCollapsed: true,
              isDense: true,
              labelStyle: TextStyle(color: textColor),
              hintStyle: TextStyle(color: textColor),
            ),
          )),
      SizedBox(width: 3),
      Text(
        '/',
        style: TextStyle(color: textColor),
      ),
      SizedBox(width: 10),
      Text(
        controller.pageCount.toString(),
        style: TextStyle(color: textColor),
      )
    ];
  }

  List<Widget> pageNavigation() {
    return [
      SizedBox(width: 20),
      IconButton(
          onPressed: controller.pageNumber > 1
              ? () {
                  setState(() {});
                  controller.previousPage();
                  pageNumber.text = controller.pageNumber.toString();
                }
              : null,
          icon: Icon(
            Icons.arrow_circle_up,
            color: controller.pageNumber > 1 ? textColor : Colors.grey,
          )),
      IconButton(
          onPressed: controller.pageNumber < controller.pageCount
              ? () {
                  setState(() {});
                  controller.nextPage();
                  pageNumber.text = controller.pageNumber.toString();
                }
              : null,
          icon: Icon(
            Icons.arrow_circle_down,
            color: controller.pageNumber < controller.pageCount
                ? textColor
                : Colors.grey,
          )),
    ];
  }

  settings() {
    return PopupMenuButton(
        icon: Icon(
          Icons.more_vert_rounded,
          color: Colors.white,
        ),
        itemBuilder: ((context) {
          return [
            PopupMenuItem(
                onTap: () {
                  setState(() {
                    pageLayoutMode = PdfPageLayoutMode.continuous;
                  });
                },
                child: Wrap(
                  children: [
                    Icon(
                      Icons.control_point_outlined,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Continous Page'),
                  ],
                )),
            PopupMenuItem(
                onTap: () {
                  setState(() {
                    pageLayoutMode = PdfPageLayoutMode.single;
                  });
                },
                child: Wrap(
                  children: [
                    Icon(
                      Icons.file_copy,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Page by page'),
                  ],
                )),
            PopupMenuItem(
                onTap: () {
                  setState(() {
                    scrollDirection = PdfScrollDirection.vertical;
                  });
                },
                child: Wrap(
                  children: [
                    Icon(
                      Icons.vertical_distribute,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Vertical Scrolling'),
                  ],
                )),
            PopupMenuItem(
                onTap: () {
                  setState(() {
                    scrollDirection = PdfScrollDirection.horizontal;
                  });
                },
                child: Wrap(
                  children: [
                    Icon(
                      Icons.horizontal_distribute,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Horizontal Scrolling'),
                  ],
                )),
          ];
        }));
  }
}
