import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import 'active_localization.dart';
import 'app_text.dart';

const _countAnswers = 4;

const _acceptedQuestionsNumbers = <int>[
  3,
  4,
  5,
  6,
  7,
  8,
  9,
];

const _acceptedAnswersNumbers = <int>[
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19
];

/// Maximum count of digits in `acceptedAnswersNumbers`.
/// \todo Automatic calculate by `acceptedAnswersNumbers`.
const _maxCountDigitsInAcceptedAnswersNumbers = 2;

final _questionFontSize = C.defaultFontSizeRelative * 2;

final _answerFontSize = _questionFontSize;

final _containerInnerPadding = C.defaultFontSizeRelative / 4;

final _dialogPadding = C.defaultFontSizeRelative * 2;

const _dialogSpread = 2.0;

const _dialogBorderRadius = 12.0;

const _dialogEmboss = false;

const _dialogContainerColor = Colors.white;

const _dialogTextColor = C.defaultButtonBackgroundColor;

final _answerContainerWidth =
    _answerFontSize * _maxCountDigitsInAcceptedAnswersNumbers +
        _containerInnerPadding * 2;

final spacerDimension = C.defaultFontSizeRelative / 3;

/// Will close when tap was fail.
@immutable
class ChildProtection extends StatelessWidget with Localization {
  final Widget? child;
  final Function() onCorrectTap;

  const ChildProtection({
    super.key,
    this.child,
    required this.onCorrectTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => onTapEvent(context),
        child: child,
      );

  void onTapEvent(BuildContext context) {
    if (C.ignoreChildProtection) {
      onCorrectTap();
      return;
    }

    final qa = _QA(
      title: localization.protection_child_dialog_title,
      countAnswers: _countAnswers,
      onCorrectTap: () async {
        await onCorrectTap();
        // ignore: use_build_context_synchronously
        _closeDialog(context);
      },
      onFailTap: () => _closeDialog(context),
    );

    AwesomeDialog(
      context: context,
      //width: _dialogContainerWidth,
      dialogType: DialogType.NO_HEADER,
      headerAnimationLoop: false,
      buttonsTextStyle: const TextStyle(color: Colors.lightGreen),
      showCloseIcon: false,
      padding: EdgeInsets.all(_dialogPadding),
      body: qa,
    ).show();
  }

  void _closeDialog(BuildContext context) =>
      Navigator.of(context, rootNavigator: true).pop();
}

class _QA extends StatefulWidget with Localization {
  final String title;
  final int countAnswers;
  final void Function() onCorrectTap;
  final void Function() onFailTap;

  const _QA({
    required this.title,
    required this.countAnswers,
    required this.onCorrectTap,
    required this.onFailTap,
  });

  @override
  // \todo Doesn't ignore `no_logic_in_create_state`.
  // ignore: no_logic_in_create_state
  _QAState createState() => _QAState(
        title: title,
        countAnswers: countAnswers,
        onCorrectTap: onCorrectTap,
        onFailTap: onFailTap,
        localizedQuestion: localization.protection_child_dialog_how_much,
      );
}

class _QAState extends State<_QA> {
  final String title;
  final int countAnswers;
  final void Function() onCorrectTap;
  final void Function() onFailTap;

  final String localizedQuestion;

  late List<int> shuffleQuestionsNumbers;
  late List<int> shuffleAnswersNumbers;
  late int a;
  late int b;
  late int result;

  final answers = <int>[];

  int get correctAnswer => answers.first;

  _QAState({
    required this.title,
    required this.countAnswers,
    required this.onCorrectTap,
    required this.onFailTap,
    required this.localizedQuestion,
  })  : assert(_acceptedQuestionsNumbers.length > 2),
        assert(_acceptedAnswersNumbers.length > 2),
        assert(countAnswers <= _acceptedAnswersNumbers.length,
            'Count answers should be less or equals `acceptedAnswersNumbers`.');

  @override
  void initState() {
    super.initState();

    shuffleQuestionsNumbers = List.of(_acceptedQuestionsNumbers)..shuffle();
    shuffleAnswersNumbers = List.of(_acceptedAnswersNumbers)..shuffle();
    a = shuffleQuestionsNumbers.first;
    b = shuffleQuestionsNumbers.last;
    result = a + b;

    answers.add(result);
    for (final answer in shuffleAnswersNumbers) {
      if (answer != result) {
        answers.add(answer);
        if (answers.length >= countAnswers) {
          break;
        }
      }
    }
    answers.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final title = InkWell(
      onTap: onFailTap,
      child: _buildTitleWidget,
    );

    final question = InkWell(
      onTap: onFailTap,
      child: _buildQuestionWidget,
    );

    final spacer = SizedBox.square(dimension: spacerDimension);

    final answers = <Widget>[];
    for (var i = 0; i < countAnswers; ++i) {
      final answer = _buildAnswerWidget(context, i);
      answers.add(answer);
      if (i < countAnswers - 1) {
        answers.add(spacer);
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        title,
        spacer,
        question,
        spacer,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: answers,
        )
      ],
    );
  }

  Widget get _buildTitleWidget => AppText(title);

  _Question get _buildQuestionWidget => _Question(
      text: localizedQuestion.isEmpty
          ? '$a + $b = ?'
          : '$localizedQuestion  $a + $b ?');

  _Answer _buildAnswerWidget(BuildContext context, int i) => _Answer(
        answer: answers[i],
        correctAnswer: result,
        onCorrectTap: onCorrectTap,
        onFailTap: onFailTap,
      );
}

@immutable
class _Question extends StatelessWidget {
  final String text;

  const _Question({
    required this.text,
  });

  @override
  Widget build(BuildContext context) => ClayContainer(
        color: _dialogContainerColor,
        borderRadius: _dialogBorderRadius,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: _containerInnerPadding),
          child: ClayText(
            text,
            color: _dialogTextColor,
            spread: _dialogSpread,
            emboss: _dialogEmboss,
            size: _questionFontSize,
          ),
        ),
      );
}

@immutable
class _Answer extends StatelessWidget {
  final int answer;
  final int correctAnswer;
  final Function() onCorrectTap;
  final Function() onFailTap;

  const _Answer({
    required this.answer,
    required this.correctAnswer,
    required this.onCorrectTap,
    required this.onFailTap,
  });

  bool get isCorrect => answer == correctAnswer;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: isCorrect ? onCorrectTap : onFailTap,
        child: ClayContainer(
          color: _dialogContainerColor,
          width: _answerContainerWidth,
          borderRadius: _dialogBorderRadius,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _containerInnerPadding),
              child: ClayText(
                answer.toString(),
                color: _dialogTextColor,
                spread: _dialogSpread,
                emboss: _dialogEmboss,
                size: _answerFontSize,
              ),
            ),
          ),
        ),
      );
}
