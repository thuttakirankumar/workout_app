import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_app/blocs/workoutCubit.dart';
import 'package:workout_app/blocs/workouts_cubit.dart';
import 'package:workout_app/helpers.dart';
import 'package:workout_app/models/workout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Super"),
        actions: [
          IconButton(onPressed: (){}, icon: const  Icon(Icons.event_available)),
          IconButton(onPressed: (){}, icon: const  Icon(Icons.settings)),

        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<WorkoutCubit, List<Workout>>
        (
          builder: (context, state){
            return ExpansionPanelList.radio(
              children: 
                state.map((workout) => ExpansionPanelRadio(
                  value: workout,
                   headerBuilder: (BuildContext context, bool isExpanded){
                    return ListTile(
                      visualDensity: const VisualDensity(
                        horizontal: 0,
                        vertical: VisualDensity.maximumDensity
                      ),
                      leading: IconButton(icon: const Icon(Icons.edit), onPressed: () { 
                        BlocProvider.of<WrkoutCubit>(context).editWorkout(workout, state.indexOf(workout));
                      },),
                      trailing: Text(formatTime(workout.getTotal(), true)),
                      title: Text(workout.title!),
                      onTap: () => isExpanded?null:BlocProvider.of<WrkoutCubit>(context).startWorkout(workout),
                    );
                   },
                   body: ListView.builder(
                    shrinkWrap: true,
                    itemCount: workout.excersises.length,
                    itemBuilder: (BuildContext context, int index){
                     return ListTile(
                      visualDensity: const VisualDensity(
                        horizontal: 0,
                        vertical: VisualDensity.maximumDensity
                      ),
                      leading: Text(formatTime(workout.excersises[index].prelude!, true)),
                      trailing: Text(formatTime(workout.excersises[index].duration!, true)),
                      title: Text(workout.excersises[index].title!),
                    );
                   }))).toList()
              ,
            );
          },
        )),
    );
  }
}