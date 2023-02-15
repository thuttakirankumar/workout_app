import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workout_app/blocs/workoutCubit.dart';
import 'package:workout_app/blocs/workouts_cubit.dart';
import 'package:workout_app/models/workout.dart';
import 'package:workout_app/screens/edit_workout.dart';
import 'package:workout_app/screens/home_page.dart';
import 'package:workout_app/screens/workout_inprogress.dart';
import 'package:workout_app/states/workout_states.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());
  HydratedBlocOverrides.runZoned(() => runApp(const WorkoutApp()), storage: storage);
}

 
class WorkoutApp extends StatelessWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Workouts',
      theme: ThemeData(
        primaryColor: Colors.blue,
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Color.fromARGB(255, 66, 74, 96)),
        )
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<WorkoutCubit>(
        create: ( BuildContext context) {
        WorkoutCubit workoutCubit = WorkoutCubit();
        if(workoutCubit.state.isEmpty){
          print("Json is loading as state is empty");
          workoutCubit.getWorkouts();
        }else{
            print("state is not empty");
        }
        return workoutCubit;
      },
      ),
      BlocProvider<WrkoutCubit>(create: (BuildContext context)=> WrkoutCubit())
        ],
        child: BlocBuilder<WrkoutCubit,WorkoutState>(
          builder: (context,state){
            if(state is WorkoutInitial){
             return const HomePage();
            }else if(state is WorkoutEditing){
              return const EditWorkoutScreen();
            }
            return WorkoutProgress();
          }) ,
        ) ,
      // home: BlocProvider<WorkoutCubit>(
      //   create: ( BuildContext context) {
      //   WorkoutCubit workoutCubit = WorkoutCubit();
      //   if(workoutCubit.state.isEmpty){
      //     print("Json is loading as state is empty");
      //     workoutCubit.getWorkouts();
      //   }else{
      //       print("state is not empty");
      //   }
      //   return workoutCubit;
      // },
      // child:BlocBuilder<WorkoutCubit, List<Workout>>(
      //   builder: (context, state) {
      //     return const HomePage();
      //   },
      // ) ,
      // ),
    );
  }
}