import 'dart:ffi';
import 'dart:isolate';

import 'configuration.dart';
import 'native/realm_core.dart';
import 'realm_object.dart';

export 'collection.dart';
export "configuration.dart";
export 'helpers.dart';
export 'realm_object.dart';
export 'results.dart';

void setRealmLib(DynamicLibrary realmLibrary) => setRealmLibrary(realmLibrary);

/// A Realm instance represents a Realm database.
class Realm {
  /// The [Configuration] object of this [Realm]
  Configuration get config => throw RealmException("not implemented");
  late RealmHandle _realm;
  late final _Scheduler _scheduler;

  /// Opens a Realm using the default or a custom [Configuration] object
  Realm(Configuration config) {
    _scheduler = _Scheduler(config);
    _realm = realmCore.openRealm(config);
  }
}

class _Scheduler {
  // ignore: constant_identifier_names
  static const dynamic SCHEDULER_FINALIZE = null;
  late final SchedulerHandle handle;

  _Scheduler(Configuration config) {
    RawReceivePort receivePort = RawReceivePort();
    receivePort.handler = (dynamic message) {
      if (message != SCHEDULER_FINALIZE) {
        realmCore.invokeScheduler(message as int);
      }

      receivePort.close();
    };

    final sendPort = receivePort.sendPort;
    handle = realmCore.createScheduler(sendPort.nativePort);

    //we use this to receive a notification on process exit to close the receivePort or the process with hang
    Isolate.spawn(handler, 2, onExit: sendPort);

    realmCore.setScheduler(config, handle);
  }

  static void handler(int message) {}
}
