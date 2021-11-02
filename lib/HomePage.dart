import 'package:camera/camera.dart';
import 'package:saude_cafe_app/core/app_images.dart';
import 'package:saude_cafe_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
{
  bool isWorking = false;
  String result="";
  CameraController cameraController;
  CameraImage imgCamera;


  loadModel() async
  {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt"
    );
  }

  initCamera()
  {
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController.initialize().then((value) {
      if(!mounted)
        {
          return;
        }

      setState(() {
        cameraController.startImageStream((imagesFromStream) =>
        {
          if(!isWorking)
          {
            isWorking = true,
            imgCamera = imagesFromStream,
            runModelOnStreamFrames(),
          }
        });
      });
    });
  }

  runModelOnStreamFrames() async
  {
    if(imgCamera != null)
    {
      var recognition = await Tflite.runModelOnFrame(
          bytesList: imgCamera.planes.map((plane)
          {
            return plane.bytes;
          }).toList(),

          imageHeight: imgCamera.height,
          imageWidth: imgCamera.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 1,
          threshold: 0.1,
          asynch: true
        );

      result = "";

      recognition.forEach((response)
      {
        result += response["label"] + " - " + (response["confidence"]*100 as double).toStringAsFixed(2) + "%\n\n";
      });

      setState(() {
        // ignore: unnecessary_statements
        result;
      });

      isWorking = false;
    }
  }

  @override
  void initState() {
    super.initState();

    loadModel();
    initCamera();
  }

  @override
  void dispose() async {
    super.dispose();

    await Tflite.close();

    cameraController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: HexColor("#00C2CB"),
            toolbarHeight: 120,
            centerTitle: true,
            leadingWidth: 80,
            leading: Container(
              padding: const EdgeInsets.only(left: 20),
              child: Image.asset(
                AppImages.logo2,
                height: 120,
                width: 120,
                alignment: Alignment.center,
              ),
            ),
            title: Text(
              "Bem-vindo",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,),
            ),
            actions: [
              Container(
                  margin: const EdgeInsets.all(26.0),
                  decoration: BoxDecoration(color: HexColor("#00C2CB"),),
                  child: TextButton(
                      child: Icon(Icons.help_outline_rounded, color: Colors.white, size: 40,),
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('AJUDA',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: HexColor("#00C2CB")),
                      ),
                        content: Image.asset(
                          AppImages.acuracia,
                          height: 300,
                          alignment: Alignment.center,
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: Text('OK',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20, color: HexColor("#00C2CB")),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
              ),
            ],
          ),
          body: Container(
            color: Colors.black,
            child: Column(
            children: [
              Stack(
            children: [
              Center(
                    child: Container (
                    child: Container(
                      height: 360,
                      width: double.maxFinite,
                      child: imgCamera == null
                          ?  Container(
                        height: 360,
                        width: double.maxFinite,
                        child: Icon(Icons.photo_camera, color: HexColor("#00C2CB").withOpacity(0.4), size: 60,),
                      )
                          : AspectRatio(
                        aspectRatio: cameraController.value.aspectRatio,
                        child: CameraPreview(cameraController),
                      ),
                    ),
                  ) ,
                ),
              ]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                      children: [
                        ListTile(
                          title: Text(
                              'RESULTADO DA ANÁLISE:',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, color: HexColor("#00C2CB")),

                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            result,
                            style: TextStyle(fontSize: 20, color: HexColor("#00C2CB"), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              )
            ],
          ),
        ),
          bottomNavigationBar: BottomAppBar(
            color: HexColor("#00C2CB"),
            child: Container(
              height: 100.0,
              child: Image.asset(AppImages.logo3),
            ),
          ),
      )
      )
    );
  }
}
