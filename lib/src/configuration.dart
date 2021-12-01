import 'package:realm_annotations/realm_annotations.dart';

import 'native/realm_core.dart';
import 'realm_object.dart';

/// Configuration used to create a [Realm] instance
class Configuration {
  final ConfigHandle handle;
  final RealmSchema _schema;

  RealmSchema get schema => _schema;

  Configuration(List<SchemaObject> schemaObjects)
      : _schema = RealmSchema(schemaObjects),
        handle = realmCore.createConfig() {
    schemaVersion = 0;
    path = "default.realm";
  }

  /// The schema version used to open the [Realm]
  ///
  /// If omitted the default value of `0` is used to open the [Realm]
  /// It is required to specify a schema version when initializing an existing
  /// Realm with a schema that contains objects that differ from their previous
  /// specification. If the schema was updated and the schemaVersion was not,
  /// an [RealmException] will be thrown.
  int get schemaVersion => realmCore.getSchemaVersion(this);
  set schemaVersion(int value) => realmCore.setSchemaVersion(this, value);

  String get path => realmCore.getConfigPath(this);
  set path(String value) => realmCore.setConfigPath(this, value);
}

class SchemaObject {
  final Type type;
  String get name => type.toString();

  final List<SchemaProperty> properties;

  const SchemaObject(this.type, this.properties);
}

class RealmSchema extends Iterable<SchemaObject> {
  late final SchemaHandle handle;

  late final List<SchemaObject> _schema;

  RealmSchema(List<SchemaObject> schemaObjects) {
    if (schemaObjects.isEmpty) {
      throw RealmException("No schema specified");
    }

    _schema = schemaObjects;
    handle = realmCore.createSchema(schemaObjects);
  }

  @override
  Iterator<SchemaObject> get iterator => _schema.iterator;

  @override
  int get length => _schema.length;

  SchemaObject operator [](int index) => _schema[index];

  @override
  SchemaObject elementAt(int index) => _schema.elementAt(index);
}
