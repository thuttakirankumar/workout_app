import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:workout_app/blocs/workouts_cubit.dart';
import 'package:workout_app/helpers.dart';
import 'package:workout_app/models/workout.dart';

class EditExcercise extends StatefulWidget {
  final Workout? workout;
  final int index;
  final int? exIndex;
  const EditExcercise(
      {super.key, this.workout, required this.index, this.exIndex});

  @override
  State<EditExcercise> createState() => _EditExcerciseState();
}

class _EditExcerciseState extends State<EditExcercise> {
  TextEditingController? title;

  @override
  void initState() {
    title = TextEditingController(
        text: widget.workout!.excersises[widget.exIndex!].title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: InkWell(
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      final controller = TextEditingController(
                          text: widget
                              .workout!.excersises[widget.exIndex!].prelude!
                              .toString());
                      return AlertDialog(
                        content: TextField(
                          controller: controller,
                          decoration:
                              const InputDecoration(labelText: "Prelude"),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                if (controller.text.isNotEmpty) {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    widget.workout!
                                            .excersises[widget.exIndex!] =
                                        widget.workout!
                                            .excersises[widget.exIndex!]
                                            .copywith(
                                                prelude:
                                                    int.parse(controller.text));
                                    BlocProvider.of<WorkoutCubit>(context)
                                        .saveWorkouts(
                                            widget.workout!, widget.index);
                                  });
                                }
                              },
                              child: const Text("Save"))
                        ],
                      );
                    });
              },
              child: NumberPicker(
                itemHeight: 30,
                value: widget.workout!.excersises[widget.exIndex!].prelude!,
                minValue: 0,
                maxValue: 3599,
                textMapper: (numberText) =>
                    formatTime(int.parse(numberText), false),
                onChanged: (value) {
                  setState(() {
                    widget.workout!.excersises[widget.exIndex!] = widget
                        .workout!.excersises[widget.exIndex!]
                        .copywith(prelude: value);
                    BlocProvider.of<WorkoutCubit>(context)
                        .saveWorkouts(widget.workout!, widget.index);
                  });
                },
              ),
            )
            ),
            Expanded(
              flex: 3,
                child: TextField(
              textAlign: TextAlign.center,
              controller: title,
              onChanged: (value) {
                setState(() {
                  widget.workout!.excersises[widget.exIndex!] = widget
                      .workout!.excersises[widget.exIndex!]
                      .copywith(title: value);
                  BlocProvider.of<WorkoutCubit>(context)
                      .saveWorkouts(widget.workout!, widget.index);
                });
              },
            )),
              Expanded(
                child: InkWell(
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      final controller = TextEditingController(
                          text: widget
                              .workout!.excersises[widget.exIndex!].duration!
                              .toString());
                      return AlertDialog(
                        content: TextField(
                          controller: controller,
                          decoration:
                              const InputDecoration(labelText: "Duration"),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                if (controller.text.isNotEmpty) {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    widget.workout!
                                            .excersises[widget.exIndex!] =
                                        widget.workout!
                                            .excersises[widget.exIndex!]
                                            .copywith(
                                                duration:
                                                    int.parse(controller.text));
                                    BlocProvider.of<WorkoutCubit>(context)
                                        .saveWorkouts(
                                            widget.workout!, widget.index);
                                  });
                                }
                              },
                              child: const Text("Save"))
                        ],
                      );
                    });
              },
              child: NumberPicker(
                itemHeight: 30,
                value: widget.workout!.excersises[widget.exIndex!].duration!,
                minValue: 0,
                maxValue: 3599,
                textMapper: (numberText) =>
                    formatTime(int.parse(numberText), true),
                onChanged: (value) {
                  setState(() {
                    widget.workout!.excersises[widget.exIndex!] = widget
                        .workout!.excersises[widget.exIndex!]
                        .copywith(duration: value);
                    BlocProvider.of<WorkoutCubit>(context)
                        .saveWorkouts(widget.workout!, widget.index);
                  });
                },
              ),
            )
            )
            
          ],
        )
      ],
    );
  }
}
