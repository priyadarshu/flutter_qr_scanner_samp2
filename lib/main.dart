import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

final fileUrl =
    "https://cdn.jsdelivr.net/gh/Monofyi/url_update@master/server.log";

var dio = Dio();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String data = "";

  void getPermission() async {
    print("getPermission");
    //Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  @override
  void initState() {
    getPermission();
    super.initState();
  }

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      data = await file.readAsString();
      setState(() {
        this.data = data;
        print(data);
      });
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton.icon(
                onPressed: () async {
                  String path =
                      await ExtStorage.getExternalStoragePublicDirectory(
                          ExtStorage.DIRECTORY_DOWNLOADS);
                  //String fullPath = tempDir.path + "/boo2.pdf'";
                  String fullPath = "$path/server.txt";
                  print('full path $fullPath');

                  download2(dio, fileUrl, fullPath);
                  //Text(data, style: TextStyle(color: Colors.red));
                },
                icon: Icon(
                  Icons.file_download,
                  color: Colors.white,
                ),
                color: Colors.green,
                textColor: Colors.white,
                label: Text('Download')),
            Text(data, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

//
//
/*
import 'dart:io';
main() {
  new HttpClient()
      .getUrl(Uri.parse(
          'https://github.com/rexdivakar/heroku-test/blob/master/File_Encryptor.py'))
      .then((HttpClientRequest request) => request.close())
      .then((HttpClientResponse response) =>
          response.pipe(new File('File_Encryptor.py').openWrite()));
}*/

// Read a data from a  file
/*import 'package:flutter/material.dart';
//import 'package:flutter/services.dart' show rootBundle;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReadFileFroGoogleDrive(),
    ),
  );
}

class ReadFileFroGoogleDrive extends StatefulWidget {
  @override
  _ReadFileFroGoogleDriveState createState() => _ReadFileFroGoogleDriveState();
}

class _ReadFileFroGoogleDriveState extends State<ReadFileFroGoogleDrive> {
  final pathUrl =
      "https://drive.google.com/file/d/17dGyk5yBsfhzplfKBgCCdTNHUY3KniGJ/view?usp=sharing";
  bool downloading = false;
  var progressString = "";

  //Response response;

  @override
  void initState() {
    super.initState();
    downloadFile();
  }

  Future<void> downloadFile() async {
    Dio dio = new Dio();

    try {
      var dir = await getApplicationSupportDirectory();

      await dio.download(pathUrl, "${dir.path}/file1.txt",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec, Total: $total");
        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: downloading
          ? Container(
              height: 120.0,
              width: 200.0,
              child: Card(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Downloading File:$progressString',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            )
          : Text("No data"),
    ));
  }
}
*/
//
//
//
//

/*

class ReadFile extends StatefulWidget {
  @override
  _ReadFileState createState() => _ReadFileState();
}

class _ReadFileState extends State<ReadFile> {
  String data = "";
  fetchFileData() async {
    String responseText;
    responseText = await rootBundle.loadString('textfile/file1.txt');

    setState(() {
      data = responseText.toString();
    });
  }

  @override
  void initState() {
    fetchFileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read file'),
      ),
      body: Center(
        child: Text(data),
      ),
    );
  }
}
*/
