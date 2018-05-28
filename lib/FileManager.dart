import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileManager {
  List<String> filenames;

  FileManager(List<String> filenames){
    this.filenames = filenames;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path+'/user_data');

    return directory.path+'/user_data';
  }

  Future<File> get _localFile async {
    String filename = filenames.last+'.txt';
    final path = await _localPath;
    return new File('$path/$filename').create(recursive: true);
  }

  Future<String> readCharacteristic() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      return 'READING FILE ERROR';
    }
  }

  Future<File> writeCharacteristic(String content) async {

    final file = await _localFile;
    // Write the file
    return file.writeAsString('$content');
  }

}