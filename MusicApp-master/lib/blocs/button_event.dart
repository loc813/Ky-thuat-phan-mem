// ignore_for_file: camel_case_types

import 'package:equatable/equatable.dart';

class playerButtonEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Previous extends playerButtonEvent {
  Previous();
}

class Play extends playerButtonEvent {
  Play();
}

class Next extends playerButtonEvent {
  Next();
}
