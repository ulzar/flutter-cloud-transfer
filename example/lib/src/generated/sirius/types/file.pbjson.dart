///
//  Generated code. Do not modify.
//  source: sirius/types/file.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const File$json = const {
  '1': 'File',
  '2': const [
    const {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'mount_id', '3': 3, '4': 1, '5': 9, '10': 'mountId'},
    const {'1': 'size', '3': 4, '4': 1, '5': 4, '10': 'size'},
    const {'1': 'type', '3': 5, '4': 1, '5': 14, '6': '.sirius.types.File.Type', '10': 'type'},
    const {'1': 'status', '3': 6, '4': 1, '5': 14, '6': '.sirius.types.File.Status', '10': 'status'},
  ],
  '4': const [File_Type$json, File_Status$json],
};

const File_Type$json = const {
  '1': 'Type',
  '2': const [
    const {'1': 'UNKNOWN', '2': 0},
    const {'1': 'DIRECTORY', '2': 1},
    const {'1': 'FILE', '2': 2},
    const {'1': 'SEQUENCE', '2': 3},
  ],
};

const File_Status$json = const {
  '1': 'Status',
  '2': const [
    const {'1': 'NONE', '2': 0},
    const {'1': 'UPLOADING', '2': 1},
    const {'1': 'DOWNLOADING', '2': 2},
    const {'1': 'MISSING', '2': 3},
    const {'1': 'READY', '2': 4},
  ],
};

