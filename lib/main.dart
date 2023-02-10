import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:voice_record_test/login_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Record Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool isRecorderReady = false;
  bool isRecording = false;

  final loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  final TextEditingController _stringController = TextEditingController();

  final recorder = FlutterSoundRecorder();
  final audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Future record() async {
    if (!isRecorderReady) {
      return;
    }
    setState(() {
      isRecording = true;
    });
    // await recorder.openAudioSession();
    await recorder.startRecorder(
      toFile: 'test.aac',
      // toFile: 'test',
      codec: Codec.aacADTS,
    );
  }

  Uint8List? fileBytes;
  String? base64;

  Future stop() async {
    if (!isRecorderReady) {
      return;
    }
    setState(() {
      isRecording = false;
    });
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    fileBytes = File(path).readAsBytesSync();
    base64 = base64Encode(fileBytes!);
    log(fileBytes.toString(), name: 'Encoded Audio');
    setState(() {
      _stringController.text = base64.toString();
    });

    // await Share.shareXFiles([XFile(audioFile.path)]);
    // await audioPlayer.play(path!, isLocal: true);
    // await audioCache.play(path);
    //  Source deviceFile = audioPlayer.setSourceDeviceFile(path);
    // await recorder.closeAudioSession();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Voice Record Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<RecordingDisposition>(
              stream: recorder.onProgress,
              builder: (context, snapshot) {
                final recording = snapshot.data;
                final duration = recording?.duration ?? Duration.zero;
                return Text(
                  '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 30),
                );
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (isRecording) {
                  await stop();
                } else {
                  await record();
                }
              },
              child: Icon(
                isRecording ? Icons.stop : Icons.mic,
                size: 30,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                await loginController.attachFile(base64 ?? '');
                if (loginController.response.value == 1) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(' Attach Success'),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Failed'),
                  ));
                }
              },
              icon: Obx(() => loginController.isLoading.value
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Icon(Icons.send)),
              label: Text('Attach file'),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _stringController,
                readOnly: true,
                maxLines: 10,
                decoration: InputDecoration(hintText: "Encoded string"),
                onChanged: (text) {
                  // This function will be called every time the user types something
                },
              ),
            ),
            // ElevatedButton(
            //     onPressed: () {
            //       setState(() {
            //         _stringController.selection = TextSelection(
            //           baseOffset: 0,
            //           extentOffset: _stringController.text.length,
            //         );
            //       });
            //     },
            //     child: Text('Select Text'))
          ],
        ),
      ),
    );
  }
}
