import 'dart:ffi';

import 'dynamiclibrary.dart';
import 'ffi.dart';

typedef InitializeDartApiCXX = Void Function(
  Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>>
      postCObject,
  Int64 nativePort,
  Pointer<Void> initializeApiDLData,
);
typedef InitializeDartApiDart = void Function(
  Pointer<NativeFunction<Int8 Function(Int64, Pointer<Dart_CObject>)>>
      postCObject,
  int nativePort,
  Pointer<Void> initializeApiDLData,
);

class DartVLC {
  static void initialize(String dynamicLibraryPath) {
    if (!isInitialized) {
      dynamicLibrary = DynamicLibrary.open(dynamicLibraryPath);
      // ignore: omit_local_variable_types
      final InitializeDartApiDart initializeDartApi = dynamicLibrary
          .lookup<NativeFunction<InitializeDartApiCXX>>('InitializeDartApi')
          .asFunction();
      initializeDartApi(
        NativeApi.postCObject,
        receiver.sendPort.nativePort,
        NativeApi.initializeApiDLData,
      );
      isInitialized = true;
    }
  }
}
