// To parse this JSON data, do
//
//     final extractImages = extractImagesFromJson(jsonString);

import 'dart:convert';

ExtractImages extractImagesFromJson(String str) =>
    ExtractImages.fromJson(json.decode(str));

String extractImagesToJson(ExtractImages data) => json.encode(data.toJson());

class ExtractImages {
  ExtractImages({
    this.conversionCost,
    this.files,
  });

  int? conversionCost;
  List<FileElement>? files;

  factory ExtractImages.fromJson(Map<String, dynamic> json) => ExtractImages(
        conversionCost: json["ConversionCost"],
        files: List<FileElement>.from(
            json["Files"].map((x) => FileElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ConversionCost": conversionCost,
        "Files": List<dynamic>.from(files!.map((x) => x.toJson())),
      };
}

class FileElement {
  FileElement({
    this.fileName,
    this.fileExt,
    this.fileSize,
    this.fileData,
  });

  String? fileName;
  String? fileExt;
  int? fileSize;
  String? fileData;

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        fileName: json["FileName"],
        fileExt: json["FileExt"],
        fileSize: json["FileSize"],
        fileData: json["FileData"],
      );

  Map<String, dynamic> toJson() => {
        "FileName": fileName,
        "FileExt": fileExt,
        "FileSize": fileSize,
        "FileData": fileData,
      };
}
