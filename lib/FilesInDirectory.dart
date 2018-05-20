import 'dart:io';

class FilesInDirectory {
  List<String> filesList = new List<String>();
  String _path= '/data/data/ru.characterist.flutterapp2/app_flutter/user_data';

getFilesFromDir(){
  // Get the system temp directory.
  var userFilesDir = new Directory(_path);

  // List directory contents, recursing into sub-directories,
  // but not following symbolic links.
  userFilesDir.list(recursive: true, followLinks: false)
      .listen((FileSystemEntity entity) {
    print(entity.path);
    filesList.add(entity.path);
  });
  return filesList;
}

}