
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:workout_app/models/excersise.dart';
import 'package:workout_app/models/workout.dart';

class WorkoutCubit extends HydratedCubit<List<Workout>>{
  WorkoutCubit(): super([]);


  getWorkouts()async{

    final List<Workout> workouts = [];

    final workoutJson = jsonDecode(await rootBundle.loadString("assets/workouts.json"));
    for(var element in (workoutJson as Iterable)){
       workouts.add(Workout.fromJson(element));
    }
    emit(workouts);
  }

  saveWorkouts(Workout workout, int index){
    Workout newWorkout = Workout(title: workout.title, excersises: []);
    int exIndex =0;
    int startTime = 0;
    for(var ex in workout.excersises){
      newWorkout.excersises.add(
        Exercise(title: ex.title, prelude: ex.prelude, duration: ex.duration, index: ex.index,startTime: ex.startTime)
      );
      exIndex++;
      startTime += ex.prelude! +ex.duration!;
    }
    state[index] = newWorkout;
    print("...no.of states ${state.length}");
    emit([...state]);
  }
  
  @override
  List<Workout>? fromJson(Map<String, dynamic> json) {
    List<Workout> workouts = [];
    json['workouts'].forEach(
      (el)=>workouts.add(Workout.fromJson(el))
    );
    return workouts;
  }
  
  @override
  Map<String, dynamic>? toJson(List<Workout> state) {
   
   if(state is List<Workout>){

    var json ={
     'workouts': [],
    };

    for(var workout in state){
      json['workouts']!.add(workout.toJson());
    }

    return json;
   }else{
    return null;
   }
  }
}