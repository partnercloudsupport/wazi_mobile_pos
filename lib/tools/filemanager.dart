import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:image_picker/image_picker.dart';

class FileManager {
  Directory _tempDirectory;
  Directory _appDirectory;

  Future<File> compressFile(
      {@required File file,
      @required double maxSizeKb,
      int minWidth = 1024,
      int minHeight = 768}) async {
    if (null == _tempDirectory) _tempDirectory = await getTemporaryDirectory();
    var originalFileName = file.path.substring(file.path.lastIndexOf("/"));

    var currentSizeKb = (file.lengthSync() / 1024);
    if (maxSizeKb > (currentSizeKb))
      return file;
    else {
      var quality = ((maxSizeKb / currentSizeKb) * 100).toInt();

      var workingFile = File("${_tempDirectory.path}$originalFileName");

      var result = await FlutterImageCompress.compressWithFile(
          file.absolute.path,
          minWidth: minWidth,
          minHeight: minHeight,
          quality: quality);

      print(workingFile.uri);

      workingFile.writeAsBytesSync(result, flush: true, mode: FileMode.write);

      return workingFile;
    }
  }

  Future<File> moveFile(
      {@required File file,
      @required String folder,
      @required String subfolder}) async {
    if (!(await file.exists())) {
      return file;
    }

    var originalFileName = file.path.substring(file.path.lastIndexOf("/"));
    File result;

    if (null == _appDirectory)
      _appDirectory = await getApplicationDocumentsDirectory();

    var newfilepath =
        "${_appDirectory.path}/$folder/$subfolder$originalFileName";

    var directoryPath = "${_appDirectory.path}/$folder/$subfolder";
    if (!Directory(directoryPath).existsSync()) {
      Directory(directoryPath).createSync(recursive: true);
    }

    print(newfilepath);

    await file.copy(newfilepath).then((newfile) {
      if (newfile == null)
        newfile = file;
      else {
        file.deleteSync();
        result = newfile;
      }
    });

    return result;
  }

  Future<File> getCameraImage(
      {bool compress = false, double maxSizeKb = 500.0}) async {
    var picture = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );

    if (picture != null && compress) {
      var compressedFile = await this.moveFile(
          file: await this.compressFile(file: picture, maxSizeKb: maxSizeKb),
          folder: "cache",
          subfolder: "images");

      return compressedFile;
    }

    return picture;
  }

  Future<File> getGalleryImage(
      {bool compress = false, double maxSizeKb = 500.0}) async {
    var picture = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (picture != null && compress) {
      var compressedFile = this.moveFile(
          file: await this.compressFile(file: picture, maxSizeKb: maxSizeKb),
          folder: "cache",
          subfolder: "images");

      return compressedFile;
    }

    return picture;
  }
}
