// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'main.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Car extends _Car with RealmObject {
  @override
  String get make => getString("make");
  @override
  set make(String value) => setString("make", value);

  static const schema = SchemaObject(Car, [
    SchemaProperty("make", RealmPropertyType.string),
  ]);
}

class Person extends _Person with RealmObject {
  @override
  String get name => getString("name");
  @override
  set name(String value) => setString("name", value);

  static const schema = SchemaObject(Person, [
    SchemaProperty("name", RealmPropertyType.string),
  ]);
}
