import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import 'package:lampsyhealth/provider/monitoringstate.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse('https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8'),
    )..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            aspectRatio: _videoPlayerController.value.aspectRatio,
            autoPlay: true,
            looping: true,
          );
        });
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final monitoringState = Provider.of<MonitoringState>(context);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Live Stream')),
      body: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
          ? Stack(
              children: [
                  // --- STREAMING O PRIVACY MODE ---
              Positioned.fill(
                  child: monitoringState.isMonitoringActive
                      ? Chewie(controller: _chewieController!)
                      : Container(
                          color: Colors.black,
                          child: const Center(
                            child: Text(
                              'Privacy Mode Activated',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ),
            Positioned(
            bottom: 20,
            right: 15,
            child: GestureDetector(
              onTap: (){                      
                setState(() {
                  monitoringState.toggleMonitoring();
                });
              },
              child: Row(
                children: [
                  Container(
                    width: 190,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text( monitoringState.isMonitoringActive ? 'Monitoring Activated' : 'Privacy Mode Activated', style: TextStyle(color: Colors.white)))),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Icon( monitoringState.isMonitoringActive ? Icons.visibility : Icons.visibility_off,
                    color: monitoringState.isMonitoringActive ? Colors.greenAccent : Colors.white,)
                  ),
                ],
              )
            ))
              ],
            )
          : const Center(child: CircularProgressIndicator(
         color: Color.fromARGB(255, 231, 93, 255),
         strokeWidth: 3,
        )),
    );
  }
}
