import 'package:equatable/equatable.dart';
import 'package:workout_app/models/excersise.dart';

class Workout extends Equatable {
  final String? title;
  final List<Exercise> excersises;

  const Workout({
    required this.title,
    required this.excersises
  });

  factory Workout.fromJson(Map<String,dynamic> json){
    List<Exercise> excersises = [];
    int index = 0;
    int startTime = 0;
    for(var ex in json['exercises'] as Iterable){
      excersises.add(Exercise.fromJson(ex, index, startTime));
      index++;
      print(".....$index.....");
      startTime = startTime + excersises.last.prelude! + excersises.last.duration!;
    }
    return Workout(title: json['title'] as String?, excersises: excersises);
  }

  Map<String,dynamic> toJson(){
    return {
     'title': title,
     'exercises' : excersises
    };
  }
   Workout copywith(String? title){
    return Workout(title: title ?? this.title, excersises: excersises);
   }

  int getTotal(){
    int time = excersises.fold(0, (prev, ex) =>prev + ex.duration! + ex.prelude! );
    return time;
  }

  Exercise getCurrentExcercise(int? elapsed)=> excersises.lastWhere((element) => element.startTime! <= elapsed!);
  
  @override
  // TODO: implement props
  List<Object?> get props => [title,excersises];
  
  @override
  // TODO: implement stringify
  bool? get stringify => true;
}
