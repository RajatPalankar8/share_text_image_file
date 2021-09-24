import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textdata = TextEditingController();
  final imageurl =
      'https://s3-us-east-2.amazonaws.com/maryville/wp-content/uploads/2020/01/20133422/software-developer-coding-500x333.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Share Text'),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: TextField(
                    controller: textdata,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Enter Message'))),
              ),
              ElevatedButton(
                child: const Text('Share Text'),
                onPressed: () async {
                  if (textdata.value.text.isNotEmpty) {
                    final url = 'https://protocoderspoint.com/';
                    await Share.share('${textdata.value.text} ${url}');
                  }
                },
              ),
              const SizedBox(height: 25),
              const Text('Share Image from internet'),
              const SizedBox(height: 15),
              Image.network(imageurl),
              ElevatedButton(
                child: const Text('Share Image'),
                onPressed: () async {
                  final uri = Uri.parse(imageurl);
                  final response = await http.get(uri);
                  final bytes = response.bodyBytes;

                  final temp = await getTemporaryDirectory();
                  final path = '${temp.path}/image.jpg';

                  File(path).writeAsBytesSync(bytes);

                  await Share.shareFiles([path], text: 'Image Shared');
                },
              ),
              const Text('Share Image from Galary'),
              const SizedBox(height: 15),
              ElevatedButton(
                child: const Text('Share From Galary'),
                onPressed: () async {
                  // pick image from Galery
                  // final imagepick = await ImagePicker().pickImage(source: ImageSource.gallery);
                  // if(imagepick == null){
                  //   return;
                  // }
                  //await Share.shareFiles([imagepack.path]);

                  // pick image from camera
                  // final imagepick = await ImagePicker().pickImage(source: ImageSource.camera);
                  // if(imagepick == null){
                  //   return;
                  // }
                  //await Share.shareFiles([imagepack.path]);



                  // pick Video from  Galary
                  // final imagepick = await ImagePicker().pickVideo(source: ImageSource.gallery);
                  // if(imagepick == null){
                  //   return;
                  // }
                  //await Share.shareFiles([imagepack.path]);

                  final result = await FilePicker.platform.pickFiles();

                  List<String>? filesss = result?.files
                      .map((file) => file.path)
                      .cast<String>()
                      .toList();

                  if (filesss == null) {
                    return;
                  }

                  await Share.shareFiles(filesss);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
