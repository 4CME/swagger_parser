// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:archive/archive.dart';
import 'package:swagger_parser/swagger_parser.dart';

void generateArchive(List<GeneratedFile> files) {
  final encoder = ZipEncoder();
  final archive = Archive();
  for (final file in files) {
    archive.addFile(ArchiveFile(file.name, file.contents.length, file.contents));
  }
  final outputStream = OutputStream();
  final bytes = encoder.encode(
    archive,
    level: Deflate.BEST_COMPRESSION,
    output: outputStream,
  );

  final blob = html.Blob(<List<int>?>[bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    // ignore: unsafe_html
    ..href = url
    ..style.display = 'none'
    ..download = 'generated.zip';
  html.document.body!.children.add(anchor);

  // download
  anchor.click();

  // cleanup
  html.document.body!.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}
