
import 'package:flutter/material.dart';
import 'package:assignment/model/HogwartCharacters.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class HogwartsCharState extends Equatable {}

class HogwartsCharLoadingState extends HogwartsCharState {
  @override
  List<Object?> get props => [];
}

class HogwartCharsLoadedState extends HogwartsCharState {
  final List<HogwartChars> hogwartChars;
  HogwartCharsLoadedState(this.hogwartChars);
  @override
  List<Object?> get props => [hogwartChars];
}

class HogwartCharsErrorState extends HogwartsCharState {
  final String error;
  HogwartCharsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}