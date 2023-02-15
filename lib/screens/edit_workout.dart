import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_app/blocs/workoutCubit.dart';
import 'package:workout_app/blocs/workouts_cubit.dart';
import 'package:workout_app/helpers.dart';
import 'package:workout_app/models/excersise.dart';
import 'package:workout_app/models/workout.dart';
import 'package:workout_app/screens/edit_excercise.dart';
import 'package:workout_app/states/workout_states.dart';

class EditWorkoutScreen extends StatefulWidget {
  const EditWorkoutScreen({super.key});

  @override
  State<EditWorkoutScreen> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: BlocBuilder<WrkoutCubit,WorkoutState>(
        builder: (context, state) {
          WorkoutEditing we = state as WorkoutEditing;
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(onPressed: () {
                 BlocProvider.of<WrkoutCubit>(context).goHome();
              },),
              title: InkWell(
                child: Text(we.workout!.title!),
                onTap: () {
                  showDialog(context: context, builder: (_){
                    final controller = TextEditingController(text: we.workout!.title!);
                     return AlertDialog(
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          labelText: "workout Title"
                        ),
                      ),
                      actions: [
                        TextButton(onPressed: (){
                          if(controller.text.isNotEmpty){
                            Navigator.of(context).pop();
                            Workout renamed = we.workout!.copywith(controller.text);
                            BlocProvider.of<WorkoutCubit>(context).saveWorkouts(renamed, we.index);
                            BlocProvider.of<WrkoutCubit>(context).editWorkout(renamed, we.index);

                          }
                        }, child: const Text("Rename")),
                      ],
                     );
                  });
                },
              ),
            ),
            body: ListView.builder(
              itemCount: we.workout!.excersises.length,
              itemBuilder: (context, index){
                Exercise ex = we.workout!.excersises[index];
                if(we.exIndex == index) {
                  return EditExcercise(index: we.index, exIndex: we.exIndex, workout: we.workout,);
                } else{
                 return ListTile(
                  leading: Text(formatTime(ex.prelude!, true)),
                  title: Text(ex.title!),
                  trailing: Text(formatTime(ex.duration!, true)),
                  onTap: () {
                    BlocProvider.of<WrkoutCubit>(context).editExcercise(index);
                  },
                );
                }
              }),
          );
        },
      ),
       onWillPop: ()=>  BlocProvider.of<WrkoutCubit>(context).goHome());
    // Scaffold(
    //   appBar: AppBar(
    //     leading: BackButton(onPressed: () {
    //       BlocProvider.of<WrkoutCubit>(context).goHome();
    //     },),
    //   ),
    //   body:const Center(child:  Text("edit screen")),
    // );
  }
}