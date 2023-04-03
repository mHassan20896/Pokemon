import 'package:equatable/equatable.dart';

class CustomException extends Equatable implements Exception {
  const CustomException(this.message);

  final String message;

  @override
  String toString() => message;

  @override
  List<Object?> get props => [message];
}
