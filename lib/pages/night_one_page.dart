import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/log.dart';
import 'package:ffmpeg_kit_flutter/session_state.dart';
import 'package:ffmpeg_kit_flutter/statistics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sports_event/models/night_one_model.dart';

class NightOnePage extends StatefulWidget {
  const NightOnePage({Key? key}) : super(key: key);

  @override
  State<NightOnePage> createState() => _NightOnePageState();
}

class _NightOnePageState extends State<NightOnePage> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _titleEditingController = TextEditingController();

  final Color fillColor = const Color(0xff2C3040);

  List<String?> mediatsList = [];
  List<double> progressValues = [];

  List<NightOneModel> downloadList = [
    NightOneModel(
        title: '绝命毒师1',
        videoUrl:
            'http://1257120875.vod2.myqcloud.com/0ef121cdvodtransgzp1257120875/3055695e5285890780828799271/v.f230.m3u8'),
  ];


  downloadVideo(List<NightOneModel> list) async {
    NightOneModel element = list.first;
    downM3u8File(element.videoUrl, element.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff1E202b),
        body: Container(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      videoUrlWidget(),
                      const SizedBox(
                        height: 8,
                      ),
                      videoTitleWidget(),
                    ],
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        downloadVideo(downloadList);
                      },
                      child: Container(
                        color: fillColor,
                        width: 70,
                        height: 70,
                        child: const Center(
                            child: Text(
                          '下载',
                          style: TextStyle(color: Colors.white),
                        )),
                      )),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: downloadListWidget(downloadList),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1, child: tsFileDownloadListWidget()),
                            const VerticalDivider(
                              color: Colors.white,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(color: fillColor),
                            )
                          ],
                        )),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  //视频地址 Widget
  Widget videoUrlWidget() {
    return Row(
      children: [
        const Text(
          '链接地址:',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                border: InputBorder.none,
                filled: true,
                isCollapsed: true,
                fillColor: fillColor),
            controller: _textEditingController,
            maxLines: 1,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }

  //视频标题 Widget
  Widget videoTitleWidget() {
    return Row(
      children: [
        const Text(
          '视频标题:',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                border: InputBorder.none,
                filled: true,
                isCollapsed: true,
                fillColor: fillColor),
            controller: _titleEditingController,
            maxLines: 1,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
        ),
      ],
    );
  }

  //下载任务队列组件
  Widget downloadListWidget(List<NightOneModel> downloadList) {
    TextStyle textStyle = const TextStyle(
      fontSize: 12,
      color: Colors.white,
    );
    return Container(
      color: fillColor,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Colors.white,
                  );
                },
                itemCount: downloadList.length,
                itemBuilder: (_, index) {
                  NightOneModel nightOneModel = downloadList[index];
                  return SizedBox(
                    height: 24,
                    child: Center(
                      child: Text(
                        nightOneModel.title,
                        style: textStyle,
                        maxLines: 1,
                      ),
                    ),
                  );
                }),
          ),
          const VerticalDivider(
            color: Colors.white,
          ),
          Expanded(
            flex: 1,
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Colors.white,
                  );
                },
                itemCount: downloadList.length,
                itemBuilder: (_, index) {
                  NightOneModel nightOneModel = downloadList[index];
                  return SizedBox(
                    height: 24,
                    child: Center(
                      child: Text(
                        nightOneModel.videoUrl,
                        style: textStyle,
                        maxLines: 1,
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  //ts文件下载队列
  Widget tsFileDownloadListWidget() {
    return Container(
      color: fillColor,
      child: ListView.separated(
          separatorBuilder: (context, index) {
            return const Divider(
              color: Colors.white,
            );
          },
          itemCount: mediatsList.length,
          itemBuilder: (_, index) {
            String? url = mediatsList[index];
            double progress = progressValues[index];
            return Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    url!,
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                    maxLines: 2,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  LinearProgressIndicator(
                    minHeight: 1,
                    backgroundColor: Colors.green,
                    color: Colors.red,
                    value: progress,
                  )
                ],
              ),
            );
          }),
    );
  }

  //1.下载.m3u8文件
  downM3u8File(String viderUrl, String videoTitle) async {
    Dio dio = Dio();
    Directory dir = await getApplicationDocumentsDirectory();
    String videoPath = "${dir.path}/temp/$videoTitle.m3u8";
    Response response = await dio.download(viderUrl, videoPath);
    if (response.statusCode == 200) {
      return parserM3u8File(dir, viderUrl, videoPath, videoTitle);
    }
  }

  //2.解析m3u8文件
   parserM3u8File(Directory dir, String viderUrl, String videoPath,
      String videoTitle) async {
    String host = viderUrl.substring(0, viderUrl.lastIndexOf('/'));
    HlsPlaylist? playList = await HlsPlaylistParser.create()
        .parse(Uri.parse(viderUrl), await File(videoPath).readAsLines());
    if (playList is HlsMasterPlaylist) {
      return false;
    } else if (playList is HlsMediaPlaylist) {
      var mediaPlaylistUrls = playList.segments.map((it) => it.url).toList();
      mediatsList = playList.segments.map((it) => it.url).toList();
      progressValues = List.filled(mediaPlaylistUrls.length, 0.0);
      for (var value in mediaPlaylistUrls) {
        String tsUrl = '$host/${value!.split('/').last}';
        File file = File('${dir.path}/temp/${value.split('/').last}');
        if (!file.existsSync()) {
          //3.创建每个片段文件
          file.create();
        }
        // 4.下载每个片段文件
        int valueIndex = mediatsList.indexOf(value);
        await Dio().download(tsUrl, file.path,
            onReceiveProgress: (int count, int total) {
          progressValues[valueIndex] = count / total;
          setState(() {});
        });
        mediatsList.removeAt(valueIndex);
      }
      String cmd =
          '-allowed_extensions ALL -i ${dir.path}/temp/$videoTitle.m3u8  "${dir.path}/$videoTitle.mp4"';
      // FFmpegKit
      // ignore: void_checks
      FFmpegKit.executeAsync(cmd);
    } 
  }

  ///4.删除临时文件
  deleteTempDirectory(Directory dir) {
    Directory directory = Directory('${dir.path}/temp');
    directory.delete(recursive: true);
    return true;
  }
}
