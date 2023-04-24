

import 'package:assignment/bloc_resources/app_events_Hogwarts.dart';
import 'package:assignment/bloc_resources/app_states_Hogwarts.dart';
import 'package:assignment/bloc_resources/repoHogwartChar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HogwartsCharBloc extends Bloc<HogwartCharEvent, HogwartsCharState> {
  final HogwartsCharRepository _repository;

  HogwartsCharBloc(this._repository) : super(HogwartsCharLoadingState()) {
    on<HogwartCharEvent>((event, emit) async {
      emit(HogwartsCharLoadingState());
      try {
        final characters = await _repository.getChars();
        emit(HogwartCharsLoadedState(characters));
      } catch (e) {
        emit(HogwartCharsErrorState(e.toString()));
      }
    });
  }
}