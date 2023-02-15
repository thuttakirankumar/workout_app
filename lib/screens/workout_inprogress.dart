import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_app/blocs/workoutCubit.dart';
import 'package:workout_app/helpers.dart';
import 'package:workout_app/models/excersise.dart';
import 'package:workout_app/models/workout.dart';
import 'package:workout_app/states/workout_states.dart';

class WorkoutProgress extends StatelessWidget {
  const WorkoutProgress({super.key});

  @override
  Widget build(BuildContext context) {
   Map<String,dynamic> getStats(Workout workout, int workoutElapsed){
    int workoutTotal = workout.getTotal();
    Exercise exercise = workout.getCurrentExcercise(workoutElapsed);
    int excerciseElapsed = workoutElapsed - exercise.startTime!;
    int excersiseRemaining = exercise.prelude! - excerciseElapsed;
    bool isPrelude = excerciseElapsed < exercise.prelude!;
    int exerciseTotal = isPrelude? exercise.prelude!:exercise.duration!;
    if(!isPrelude){
      excerciseElapsed -= exercise.prelude!;
      excersiseRemaining += exercise.duration!;
    }

    return {
      "workoutTitle": workout.title,
      "workoutProgress": workoutElapsed/workoutTotal,
      "workoutElapsed":workoutElapsed,
      "totalExcercise":workout.excersises.length,
      "currentExcerciseIndex": exercise.index!.toDouble(),
      "workoutRemaining": workoutTotal-workoutElapsed,
      "excerciseRemaining": excersiseRemaining,
      "isPrelude": isPrelude,
      "excerciseProgress": excerciseElapsed/exerciseTotal,

    };
   }

    return BlocConsumer<WrkoutCubit,WorkoutState>(
      builder: (context,state){
        final stats= getStats(state.workout!, state.elapsed!);
        return Scaffold(
          appBar: AppBar(
            title: Text(state.workout!.title.toString()),
            leading: BackButton(onPressed: () => BlocProvider.of<WrkoutCubit>(context).goHome(),),
          ),
          body: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                LinearProgressIndicator(
                  backgroundColor: Colors.blue[100],
                  minHeight: 10,
                  value: stats['workoutProgress'],
                ),
                Padding(padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatTime(stats['workoutElapsed'], true)),
                    DotsIndicator(dotsCount: stats['totalExcercise'],position: stats['currentExcerciseIndex'],),
                    Text('-${formatTime(stats['workoutRemaining'], true)}'),

                  ],
                ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    if(state is WorkoutInProgress){
                      BlocProvider.of<WrkoutCubit>(context).pauseworkout();
                    }else if(state is WorkoutPaused ){
                      BlocProvider.of<WrkoutCubit>(context).resumeworkout();
                    }
                  },
                  child: Stack(
                    alignment: const Alignment(0,0),
                    children: [

                      Center(
                        child: SizedBox(
                          width: 220,
                          height: 220,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              stats['isPrelude']?Colors.red:Colors.blue
                            ),
                            strokeWidth: 25,
                            value: stats['excerciseProgress'],

                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 300,
                          height: 300,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Image.asset('stopwatch.png'),
                          )),
                      )
                    ],
                  ),
                )
              ],

            ),

          ),

        );
      },
       listener: (context,state){

       }
       );
  }
}