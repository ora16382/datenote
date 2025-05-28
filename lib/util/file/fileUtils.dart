import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

import '../../main.dart';

class FileUtils {
  // ignore: slash_for_doc_comments
  /**
   * @author JungJunHyung
   * @since 2022/08/03
   * @comment url로 파일을 불러와서 파일로 다뤄야 할 경우 사용한다.
   **/
  static Future<XFile> networkToXFile(String path, String filename) async {
    final response = await http.get(Uri.parse(path));

    final tempDir = await tempDirectoryCheck();

    final file = File(join(tempDir.path, filename));

    file.writeAsBytesSync(response.bodyBytes);

    /// 파일이 없을 경우 response.bodyBytes 의 length 는 237 이다.
    /// 서버에서 원할하게 삭제 할 수 있게 하기 위하여 여기서 예외처리 하지 않는다.
    /// 위와 같은 경우 비어있는 파일이 생성되어지며 이미지는 기본 에러 파일로 표시된다.

    XFile xFile = XFile(
      file.path,
      name: filename,
      length: file.lengthSync(),
      bytes: file.readAsBytesSync(),
      mimeType: filename.split('.').last,
    );

    return xFile;
  }

  static Future<XFile> assetToXFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);

    final tempDir = await getTemporaryDirectory();

    final tempFile = File(join(tempDir.path, Uuid().v4()));

    await tempFile.writeAsBytes(byteData.buffer.asUint8List());

    return XFile(tempFile.path);
  }

  // ignore: slash_for_doc_comments
  /**
   * @author JungJunHyung
   * @since 2022/08/03
   * @comment uInt8List 로 File 객체를 생성하는 메서드
   **/
  static Future<File> uInt8ListToFile(String filename, List<int> bytes) async {
    final tempDir = await tempDirectoryCheck();

    var file = File(join(tempDir.path, filename));
    file.writeAsBytesSync(bytes);

    return file;
  }

  // ignore: slash_for_doc_comments
  /**
   * @author JungJunHyung
   * @since 2022/08/03
   * @comment 로컬 저장소에 저장된 파일 1개를 삭제한다.
   **/
  static Future<void> deleteFile(String path) async {
    final file = File(path);

    if (await file.exists()) {
      await file.delete();
    }
  }

  // ignore: slash_for_doc_comments
  /**
   * @author JungJunHyung
   * @since 2022/08/03
   * @comment 임시 디렉터리 삭제하는 함수
   *          로컬저장소에 저장된 임시 파일들을 일괄적으로 삭제하기 위해 사용한다.
   **/
  static Future deleteTempFileStorage() async {
    final documentDirectory = await getApplicationDocumentsDirectory();

    /// 임시 폴더 저장 경로 (iOS 공통)
    deleteDir(Directory(join(documentDirectory.path, 'temp_dir')));

    /// android 이미지 선택기, 카메라 촬영 파일 임시 저장 경로 (getTemporaryDirectory)
    deleteDir(Directory('/data/user/0/jh.project.datenote/cache/'));

    /// 241212 추가 / iOS 는 임시 디렉토리를 동적으로 관리하므로 삭제할 필요가 없다.
    /// iOS 이미지 선택기, 카메라 촬영 파일 임시 저장 경로
    /// deleteDir(Directory(join('/private/', documentDirectory.path.substring(1).replaceFirst('/Documents', ''), 'tmp')));

    /// 동영상 압축 파일 저장 경로 (AOS 에서만 사용)
    deleteDir(Directory('/storage/emulated/0/Android/data/jh.project.datenote/files/video_compress/'));
  }

   /// @author 정준형
    /// @since 2025. 5. 21.
    /// @comment 디렉터리 삭제
    ///
  static Future<void> deleteDir(Directory dir) async {
    if (await dir.exists()) {
      dir.deleteSync(recursive: true);
    }
  }

  // ignore: slash_for_doc_comments
  /**
   * @author JungJunHyung
   * @since 2022/08/03
   * @comment 임시 디렉터리 생성하는 함수, 존재하지 않을 경우에만 생성하며
   *          네트워크로 불러온 임시 이미지를 저장할때 임시 디렉터리에 저장한다.
   **/
  static Future<Directory> tempDirectoryCheck() async {
    /// /data/user/0/(project_identifier)/app_flutter
    final documentDirectory = await getApplicationDocumentsDirectory();

    Directory tempDir = Directory(join(documentDirectory.path, 'temp_dir'));

    if (!await tempDir.exists()) {
      await tempDir.create();
    }

    return tempDir;
  }

  // ignore: slash_for_doc_comments
  /**
   * @author JungJunHyung
   * @since 2022/08/03
   * @comment 파라미터로 넘겨받은 이미지 bytes 값을 사용하여 압축 이미지 파일을 생성해서 리턴한다.
   **/
  static Future<XFile> getCompressImage(XFile xFile) async {
    String filename = xFile.name;

    filename = '${Uuid().v4()}_$filename';

    var file = File(xFile.path);

    String webpFileName = filename.lastIndexOf('.') == -1 ? '$filename.webp' : '${filename.substring(0, filename.lastIndexOf('.'))}.webp' ;

    File? compressFile = await compressAndGetFile(file, 'compress_$webpFileName');

    /// 압축이 성공했을 경우 이미지 교체
    if (compressFile != null) file = compressFile;

    return XFile(file.path, name: file.path.split('/').last, length: file.lengthSync(), bytes: file.readAsBytesSync(), mimeType: filename.split('.').last);
  }

  // ignore: slash_for_doc_comments
  /**
   * @author JungJunHyung
   * @since 2022/08/03
   * @comment 이미지 압축 메서드
   **/
  static Future<File?> compressAndGetFile(File file, String targetFileName) async {
    File? resultFile;

    var compressImage = await FlutterImageCompress.compressWithFile(
      file.path,
      format: CompressFormat.webp,
      quality: 80,
    );

    if (compressImage != null) {
      await deleteFile(file.path);
      resultFile = await uInt8ListToFile(targetFileName, compressImage);
    }

    return resultFile;
  }
}
