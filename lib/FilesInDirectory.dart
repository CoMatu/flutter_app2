import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FilesInDirectory {
  List<File> files = <File>[];

  Future<List<File>> filesInDirectory() async {
    final directory1 = await getApplicationDocumentsDirectory();
    String pathUser = directory1.path+'/user_data';
//    new Directory(pathUser).create(recursive: true);
    Directory dir = new Directory(pathUser);
    await for (FileSystemEntity entity in dir.list(
        recursive: false,
        followLinks: false)) {
      FileSystemEntityType type = await FileSystemEntity.type(entity.path);
      if (type == FileSystemEntityType.file) {
        files.add(entity);
        print(entity.path);
      }
    }
    return files;
  }

}