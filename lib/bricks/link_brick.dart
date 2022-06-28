import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_text.dart';
import '../child_protection.dart';
import 'button_brick.dart';
import 'text_brick.dart';

class LinkBrick extends TextBrick {
  final String link;
  final bool hasChildProtection;
  final bool likeButton;

  final void Function(BuildContext)? onPressCorrectAnswer;

  @override
  TextStyle get style => super.style.copyWith(color: Colors.blueAccent);

  const LinkBrick({
    Key? key,
    required String text,
    required this.link,
    required this.hasChildProtection,
    required this.likeButton,
    double? scale,
    bool? wrapWords,
    double? minFontSize,
    double? maxFontSize,
    int? maxLines,
    this.onPressCorrectAnswer,
    TextStyle? style,
  }) : super(
          key: key,
          text: text,
          scale: scale,
          style: style,
          wrapWords: wrapWords,
          minFontSize: minFontSize,
          maxFontSize: maxFontSize,
          maxLines: maxLines,
        );

  factory LinkBrick.fromJson(Map<String, dynamic> json) => LinkBrick(
        text: json['text'] as String,
        link: json['link'] as String,
        hasChildProtection: (json['hasChildProtection'] ?? true) as bool,
        likeButton: (json['likeButton'] ?? false) as bool,
        scale: (json['scale'] ?? 1.0) as double,
        wrapWords: (json['wrapWords'] ?? false) as bool,
        minFontSize: json['minFontSize'] as double?,
        maxFontSize: json['maxFontSize'] as double?,
        maxLines: json['maxLines'] as int?,
      );

  @override
  LinkBrick copyWith({
    String? text,
    String? link,
    bool? hasChildProtection,
    bool? likeButton,
    double? scale,
    bool? wrapWords,
    double? minFontSize,
    double? maxFontSize,
    int? maxLines,
    TextStyle? style,
  }) =>
      LinkBrick(
        key: key,
        text: text ?? this.text,
        link: link ?? this.link,
        hasChildProtection: hasChildProtection ?? this.hasChildProtection,
        likeButton: likeButton ?? this.likeButton,
        scale: scale ?? this.scale,
        wrapWords: wrapWords ?? this.wrapWords,
        minFontSize: minFontSize ?? this.minFontSize,
        maxFontSize: maxFontSize ?? this.maxFontSize,
        maxLines: maxLines ?? this.maxLines,
        style: style ?? this.style,
      );

  @override
  Widget build(BuildContext context) =>
      likeButton ? _buildLikeButton(context) : _buildLikeText(context);

  Widget _buildLikeButton(BuildContext context) => ButtonBrick(
        text: text,
        hasChildProtection: hasChildProtection,
        scale: scale,
        wrapWords: wrapWords,
        minFontSize: minFontSize,
        maxFontSize: maxFontSize,
        maxLines: maxLines,
        onPress: () => _launchUrl(context),
      );

  Widget _buildLikeText(BuildContext context) {
    final linkedText = AppText(
      text,
      scale: scale,
      textStyle: style,
      wrapWords: wrapWords,
      minFontSize: minFontSize,
      maxFontSize: maxFontSize,
      maxLines: maxLines,
    );

    return hasChildProtection
        ? ChildProtection(
            child: linkedText,
            onCorrectTap: () => _launchUrl(context),
          )
        : InkWell(
            child: linkedText,
            onTap: () => _launchUrl(context),
          );
  }

  Future<void> _launchUrl(BuildContext context) async {
    Fimber.i('Launching a link `$link`...');
    if (!await launchUrl(Uri.parse(link))) {
      throw "Couldn't launch `$link`.";
    }

    if (onPressCorrectAnswer != null) {
      // ignore: use_build_context_synchronously
      onPressCorrectAnswer!(context);
    }
  }
}
