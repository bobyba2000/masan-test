import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/web.dart';
import 'package:web_test/generated/assets.gen.dart';
import 'package:web_test/model/question/model.dart';
import 'package:web_test/model/result/model.dart';
import 'package:web_test/model/result/user_answer/model.dart';
import 'package:web_test/service/local.dart';
import 'package:web_test/service/question.dart';
import 'package:web_test/service/result.dart';
import 'package:web_test/ui/main/dialog/choose_test.dart';
import 'package:web_test/utility/loading.dart';

class TestPage extends StatefulWidget {
  final TestType type;
  const TestPage({super.key, required this.type});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final QuestionService service = QuestionService();
  final ResultService resService = ResultService();
  final logger = Logger();
  List<QuestionModel> questions = [];
  late ResultModel res;
  List<int> answers = [];
  late Timer _timer;
  late int time;
  int currentIndex = -1;
  late DateTime startTime;

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> getQuestions() async {
    List<QuestionModel> numericalQuestions = [];
    // List<QuestionModel> technicalQuestions = [];
    List<QuestionModel> scenarioQuestions = [];
    List<QuestionModel> logicalQuestions = [];
    List<QuestionModel> verbalQuestions = [];

    LoadingUtility.show();
    try {
      await Future.wait([
        () async {
          numericalQuestions = await service.getNumericalQuestion();
          numericalQuestions = getRandomQuestions(QuestionType.numerical, numericalQuestions);
        }.call(),
        () async {
          logicalQuestions = await service.getLogicalQuestion();
          logicalQuestions = getRandomQuestions(QuestionType.logical, logicalQuestions);
        }.call(),
        () async {
          verbalQuestions = await service.getVerbalQuestion();
          verbalQuestions = getRandomQuestions(QuestionType.verbal, verbalQuestions);
        }.call(),
        // () async {
        //   final questions = await service.getTechnicalQuestions();
        //   for (var type in QuestionType.values) {
        //     if (type == QuestionType.numerical) {
        //       continue;
        //     }
        //     if (type == QuestionType.scenario) {
        //       continue;
        //     }
        //     technicalQuestions.addAll(getRandomQuestions(type, questions));
        //   }
        //   technicalQuestions.shuffle();
        // }.call(),
        () async {
          scenarioQuestions = await service.getScenarioQuestion();
          scenarioQuestions = getRandomQuestions(QuestionType.scenario, scenarioQuestions);
          scenarioQuestions.sort((a, b) => (a.scenario ?? '').compareTo(b.scenario ?? ''));
        }.call(),
      ]);
    } catch (e) {
      logger.e(e);
    } finally {
      questions = [
        ...numericalQuestions,
        // ...technicalQuestions,
        ...scenarioQuestions,
        ...logicalQuestions,
        ...verbalQuestions,
      ];
      final username = await LocalStorageUtility.getData('username');
      res = ResultModel(
        username: username ?? '',
        type: widget.type,
        time: 0,
        answers: List.generate(
          questions.length,
          (index) => UserAnswerModel(
            point: 0,
            question: questions[index],
            answer: -1,
            time: 0,
          ),
        ),
        point: 0,
      );
      for (var question in questions) {
        if (question.type == QuestionType.logical) {
          question.answers.sort((a, b) => a.answer.compareTo(b.answer));
        } else if (question.type == QuestionType.verbal) {
          question.answers.sort((a, b) => b.answer.compareTo(a.answer));
        } else {
          question.answers.shuffle();
        }
        answers.add(-1);
      }
      startTime = DateTime.now();
      currentIndex = 0;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (time == 0) {
          _timer.cancel();
          onChangeQuestion(-1);
        }
        setState(() {
          time--;
        });
      });
      if (mounted) {
        setState(() {});
      }
      LoadingUtility.dismiss();
    }
  }

  List<QuestionModel> getRandomQuestions(QuestionType type, List<QuestionModel> questions) {
    final questionTypes = questions.where((element) => element.type == type).toList();
    final totalQuestions = widget.type.testStructure[type] ?? 0;
    questionTypes.shuffle();
    return questionTypes.getRange(0, totalQuestions).toList();
  }

  @override
  void initState() {
    time = widget.type.timeToComplete * 60;
    questions = [];
    getQuestions();
    super.initState();
  }

  void onChangeQuestion(int newIndex) {
    res.answers[currentIndex].answer = answers[currentIndex];
    res.answers[currentIndex].point = answers[currentIndex] == -1 ? 0 : questions[currentIndex].answers[answers[currentIndex]].point;
    res.answers[currentIndex].time += ((DateTime.now().millisecondsSinceEpoch - startTime.millisecondsSinceEpoch) / 1000);

    if (newIndex == -1) {
      onSubmit(context);
      return;
    }
    currentIndex = newIndex;
    startTime = DateTime.now();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              Assets.images.bgTest.path,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 50.h,
          horizontal: 100.w,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (questions.isNotEmpty)
                          Builder(builder: (context) {
                            final question = questions[currentIndex];
                            final answer = answers[currentIndex];
                            return QuestionWidget(
                              question: question,
                              index: currentIndex,
                              answer: answer,
                              onSelect: (value) {
                                answers[currentIndex] = value;
                                setState(() {});
                              },
                            );
                          }),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (currentIndex > 0)
                              SizedBox(
                                width: 100.w,
                                height: 50.h,
                                child: FilledButton(
                                  onPressed: () {
                                    onChangeQuestion(currentIndex - 1);
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    backgroundColor: const MaterialStatePropertyAll(Colors.grey),
                                  ),
                                  child: Text(
                                    'Back',
                                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 24),
                            if (currentIndex < (questions.length - 1))
                              SizedBox(
                                width: 100.w,
                                height: 50.h,
                                child: FilledButton(
                                  onPressed: () {
                                    onChangeQuestion(currentIndex + 1);
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Next',
                                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                  color: Theme.of(context).colorScheme.background,
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.alarm,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 16),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Remaining Time: '.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              _printDuration(
                                Duration(
                                  seconds: time,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        itemBuilder: (context, index) {
                          final answer = answers[index];

                          return InkWell(
                            onTap: () {
                              onChangeQuestion(index);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: currentIndex == index
                                    ? const Color(0xFFed732f)
                                    : answer == -1
                                        ? Colors.grey
                                        : Colors.blue.shade900,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 40,
                              alignment: Alignment.center,
                              child: Text(
                                (index + 1).toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: answers.length,
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 40,
                      width: 80,
                      child: FilledButton(
                        style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () {
                          onChangeQuestion(-1);
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSubmit(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Alert?'),
        content: const Text('Are you sure you want to submit this?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    ).then((value) async {
      if (value == true) {
        LoadingUtility.show();
        double time = 0;
        int point = 0;
        try {
          for (var i = 0; i < res.answers.length; i++) {
            time += res.answers[i].time;
            point += res.answers[i].point;
          }
          res.time = time;
          res.point = point;
          resService.submitResult(res);
        } catch (e) {
          logger.e(e);
        } finally {
          LoadingUtility.dismiss();
        }
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Thank you'),
            content: const Text('Masan Consumer thank you for your effort and time. We will inform you of your test result soon.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ).then(
          (value) => Navigator.pop(context),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class QuestionWidget extends StatefulWidget {
  final int index;
  final QuestionModel question;
  final int answer;
  final void Function(int index) onSelect;
  const QuestionWidget({
    super.key,
    required this.question,
    required this.index,
    required this.onSelect,
    required this.answer,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  int selectedAnswer = -1;

  @override
  void initState() {
    selectedAnswer = widget.answer;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant QuestionWidget oldWidget) {
    if (oldWidget.answer != widget.answer) {
      setState(() {
        selectedAnswer = widget.answer;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.question.scenario != null)
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Text(
              'Scenario: ${widget.question.scenario}',
              style: TextStyle(
                fontSize: 18.sp,
                color: const Color(0xFF838282),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

        Text(
          'Question #${widget.index + 1}:',
          style: TextStyle(
            fontSize: 22.sp,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.h),
        // if (widget.question.url != null && widget.question.url!.isNotEmpty)
        Center(
          child: Builder(builder: (context) {
            final url = widget.question.url;
            RegExp regExp = RegExp(r"/d/([a-zA-Z0-9_-]+)");
            Match? match = regExp.firstMatch(url ?? '');
            String? fileId;
            if (match != null && match.groupCount >= 1) {
              fileId = match.group(1);
            }
            if (fileId != null) {
              return Container(
                padding: EdgeInsets.only(bottom: 10.h),
                height: 300.h,
                child: Image.network('https://lh3.googleusercontent.com/d/$fileId'),
              );
            }
            return Container();
          }),
        ),
        Text(
          widget.question.question,
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          itemBuilder: (context, index) {
            final answer = widget.question.answers[index];
            final isSelected = index == selectedAnswer;
            return InkWell(
              onTap: () {
                setState(() {
                  selectedAnswer = index;
                });
                widget.onSelect.call(index);
              },
              child: Row(
                children: [
                  Radio<int>(
                    value: index,
                    groupValue: selectedAnswer,
                    onChanged: (value) {
                      setState(() {
                        selectedAnswer = index;
                      });
                      widget.onSelect.call(index);
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      answer.answer,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemCount: widget.question.answers.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
      ],
    );
  }
}
