import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart' hide Card;

import '../app_file_managers.dart';
import '../config.dart';
import '../rounded_widget.dart';
import 'preview_card.dart';

class ImageCardPreview extends StatelessWidget {
  static const preferredWidth = 256;
  static const preferredHeight = 256;

  final PreviewCard previewCard;

  final Widget? topChild;

  final int width;
  final int height;

  final VoidCallback? onPressed;

  const ImageCardPreview({
    super.key,
    required this.previewCard,
    int? width,
    int? height,
    this.topChild,
    this.onPressed,
  })  : width = width ?? preferredWidth,
        height = height ?? preferredHeight;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (topChild != null) topChild!,
            _buildFuture(),
          ],
        ),
      );

  Widget _buildFuture() => FutureBuilder<Widget>(
        future: _loadPreview(),
        builder: (context, snapshot) => snapshot.hasData
            ? RoundedWidget(child: snapshot.data!)
            : SizedBox(
                width: width + RoundedWidget.defaultWidthWithoutContent,
                height: height + RoundedWidget.defaultHeightWithoutContent,
              ),
      );

  Future<Widget> _loadPreview() async {
    final fm = AppFileManagerLocalPriority();
    final path = previewCard.previewsPaths.first;
    if (C.debugBloc) {
      Fimber.i('getting preview image from local storage priority'
          ' by path `$path`...');
    }
    final image = await fm.loadImageWidget(
      path,
      width: width.toDouble(),
      height: height.toDouble(),
    );
    if (image == null) {
      Fimber.w('Not found preview image by path `$path`.');
      return Container();
    }

    return image;
  }
}
