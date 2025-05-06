import 'package:hive/hive.dart';

part 'person.g.dart';

@HiveType(typeId: 1)
class Person {
  Person({required this.age, required this.name});
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  // @HiveField(2)
  // List<Person> friends;
}
