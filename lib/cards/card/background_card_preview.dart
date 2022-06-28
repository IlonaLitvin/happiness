import 'dart:io' show File;
import 'dart:ui' show ImageFilter;

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart' hide Card;

import '../../app_file_managers.dart';
import '../../config.dart';
import '../preview_card.dart';

class BackgroundCardPreview extends StatelessWidget {
  final String cardId;

  const BackgroundCardPreview({super.key, required this.cardId});

  @override
  Widget build(BuildContext context) => _buildFuture();

  Widget _buildFuture() => FutureBuilder<File?>(
        future: _loadPreviewFile(),
        builder: (context, snapshot) =>
            snapshot.hasData ? _buildPreview(snapshot.data!) : blackScreen,
      );

  Future<File?> _loadPreviewFile() async {
    final previewCard = await PreviewCard.fromId(cardId);
    if (previewCard == null) {
      Fimber.w('Not found a card by id `$previewCard`.');
      return null;
    }

    final fm = AppFileManagerLocalPriority();

    final path = previewCard.previewsPaths.first;
    if (C.debugBloc) {
      Fimber.i('getting background preview image from local storage priority'
          ' by path `$path`...');
    }
    final file = await fm.loadFile(path);
    if (file == null) {
      Fimber.w('Not found preview image by path `$path`.');
      return null;
    }

    return file;
  }

  Widget _buildPreview(File file) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(file),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: C.previewBlurSigma,
            sigmaY: C.previewBlurSigma,
          ),
          child: Container(
            color: Colors.white.withOpacity(0),
          ),
        ),
      );

  Widget get blackScreen => Container(color: Colors.black);
}
