import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class HogwartCharEvent extends Equatable {
  const HogwartCharEvent();
}

class LoadHogwartCharEvent extends HogwartCharEvent {
  @override
  List<Object?> get props => [];
}