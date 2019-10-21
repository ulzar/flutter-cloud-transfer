///
//  Generated code. Do not modify.
//  source: sirius/services/service.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const FilesListRequest$json = const {
  '1': 'FilesListRequest',
  '2': const [
    const {'1': 'mount_id', '3': 1, '4': 1, '5': 9, '10': 'mountId'},
    const {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
  ],
};

const FilesListResponse$json = const {
  '1': 'FilesListResponse',
  '2': const [
    const {'1': 'mount_id', '3': 1, '4': 1, '5': 9, '10': 'mountId'},
    const {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    const {'1': 'file', '3': 3, '4': 1, '5': 11, '6': '.sirius.types.File', '10': 'file'},
    const {'1': 'region', '3': 4, '4': 1, '5': 9, '10': 'region'},
  ],
};

const FilesListRepeatedResponse$json = const {
  '1': 'FilesListRepeatedResponse',
  '2': const [
    const {'1': 'files', '3': 3, '4': 3, '5': 11, '6': '.sirius.types.File', '10': 'files'},
  ],
};

const FileContentsRequest$json = const {
  '1': 'FileContentsRequest',
  '2': const [
    const {'1': 'mount_id', '3': 1, '4': 1, '5': 9, '10': 'mountId'},
    const {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    const {'1': 'chunk_size', '3': 3, '4': 1, '5': 3, '10': 'chunkSize'},
  ],
};

const FileContentsResult$json = const {
  '1': 'FileContentsResult',
  '2': const [
    const {'1': 'bytes', '3': 1, '4': 1, '5': 12, '10': 'bytes'},
    const {'1': 'bytes_remaining', '3': 2, '4': 1, '5': 3, '10': 'bytesRemaining'},
  ],
};

const FileDownloadRequest$json = const {
  '1': 'FileDownloadRequest',
  '2': const [
    const {'1': 'mount_id', '3': 1, '4': 1, '5': 9, '10': 'mountId'},
    const {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
  ],
};

const FileDownloadResponse$json = const {
  '1': 'FileDownloadResponse',
  '2': const [
    const {'1': 'bytes', '3': 1, '4': 1, '5': 12, '10': 'bytes'},
    const {'1': 'bytes_remaining', '3': 2, '4': 1, '5': 3, '10': 'bytesRemaining'},
  ],
};

const MountsRequest$json = const {
  '1': 'MountsRequest',
};

const MountsResult$json = const {
  '1': 'MountsResult',
  '2': const [
    const {'1': 'mounts', '3': 1, '4': 3, '5': 11, '6': '.sirius.types.Mount', '10': 'mounts'},
  ],
};

const FileUploadRequest$json = const {
  '1': 'FileUploadRequest',
  '2': const [
    const {'1': 'chunk_size', '3': 3, '4': 1, '5': 3, '10': 'chunkSize'},
    const {'1': 'bytes', '3': 4, '4': 1, '5': 12, '10': 'bytes'},
  ],
};

const FileUploadResponse$json = const {
  '1': 'FileUploadResponse',
};

const MkDirRequest$json = const {
  '1': 'MkDirRequest',
  '2': const [
    const {'1': 'mount_id', '3': 1, '4': 1, '5': 9, '10': 'mountId'},
    const {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
  ],
};

const MkDirResponse$json = const {
  '1': 'MkDirResponse',
};

