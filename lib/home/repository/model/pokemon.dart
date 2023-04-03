import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class Pokemon  extends Equatable{
  final String name;
  final String url;

  Pokemon({required this.name, required this.url});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final url = json['url'];

    return Pokemon(name: name ?? "", url: url ?? "");
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }

  @override
  List<Object?> get props => [name, url];
}
