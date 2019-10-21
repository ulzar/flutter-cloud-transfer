///
//  Generated code. Do not modify.
//  source: sirius/types/file.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class File_Type extends $pb.ProtobufEnum {
  static const File_Type UNKNOWN = File_Type._(0, 'UNKNOWN');
  static const File_Type DIRECTORY = File_Type._(1, 'DIRECTORY');
  static const File_Type FILE = File_Type._(2, 'FILE');
  static const File_Type SEQUENCE = File_Type._(3, 'SEQUENCE');

  static const $core.List<File_Type> values = <File_Type> [
    UNKNOWN,
    DIRECTORY,
    FILE,
    SEQUENCE,
  ];

  static final $core.Map<$core.int, File_Type> _byValue = $pb.ProtobufEnum.initByValue(values);
  static File_Type valueOf($core.int value) => _byValue[value];

  const File_Type._($core.int v, $core.String n) : super(v, n);
}

class File_Status extends $pb.ProtobufEnum {
  static const File_Status NONE = File_Status._(0, 'NONE');
  static const File_Status UPLOADING = File_Status._(1, 'UPLOADING');
  static const File_Status DOWNLOADING = File_Status._(2, 'DOWNLOADING');
  static const File_Status MISSING = File_Status._(3, 'MISSING');
  static const File_Status READY = File_Status._(4, 'READY');

  static const $core.List<File_Status> values = <File_Status> [
    NONE,
    UPLOADING,
    DOWNLOADING,
    MISSING,
    READY,
  ];

  static final $core.Map<$core.int, File_Status> _byValue = $pb.ProtobufEnum.initByValue(values);
  static File_Status valueOf($core.int value) => _byValue[value];

  const File_Status._($core.int v, $core.String n) : super(v, n);
}

