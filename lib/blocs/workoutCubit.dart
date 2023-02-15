import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock/wakelock.dart';
import 'package:workout_app/models/workout.dart';

import '../states/workout_states.dart';

class WrkoutCubit extends Cubit<WorkoutState>{
  WrkoutCubit():super(const WorkoutInitial());

  editWorkout(Workout workout, int index)=> emit(WorkoutEditing(workout, index, null));

   editExcercise(int exIndex){
    print("My Excercise  is $exIndex");
    emit(WorkoutEditing(state.workout, (state as WorkoutEditing).index, exIndex));
    }
    pauseworkout()=>emit(WorkoutPaused(state.workout, state.elapsed));
    resumeworkout()=>emit(WorkoutInProgress(state.workout, state.elapsed));

    Timer? _timer;
    onTick(Timer timer){
      if(state is WorkoutInProgress){
        WorkoutInProgress wip = state as WorkoutInProgress;
        if(wip.elapsed! < wip.workout!.getTotal()){
          emit(WorkoutInProgress(wip.workout, wip.elapsed!+1));
          print("...ElapsedTime is ${wip.elapsed}");
        }else{
          _timer!.cancel();
          Wakelock.disable();
          emit(const WorkoutInitial());
        }

      }

    }

    startWorkout(Workout workout, {int? index}){
      Wakelock.enabled;
      if(index!= null){

      }else{
        emit(WorkoutInProgress(workout, 0));
      }
      _timer = Timer.periodic(const Duration(seconds: 1), onTick);

    }


  goHome()=> emit(const WorkoutInitial());

}