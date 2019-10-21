///
//  Generated code. Do not modify.
//  source: sirius/services/service.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../types/file.pb.dart' as $1;
import '../types/mount.pb.dart' as $2;

class FilesListRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FilesListRequest', package: const $pb.PackageName('sirius.services'), createEmptyInstance: create)
    ..aOS(1, 'mountId')
    ..aOS(2, 'path')
    ..hasRequiredFields = false
  ;

  FilesListRequest._() : super();
  factory FilesListRequest() => create();
  factory FilesListRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FilesListRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FilesListRequest clone() => FilesListRequest()..mergeFromMessage(this);
  FilesListRequest copyWith(void Function(FilesListRequest) updates) => super.copyWith((message) => updates(message as FilesListRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FilesListRequest create() => FilesListRequest._();
  FilesListRequest createEmptyInstance() => create();
  static $pb.PbList<FilesListRequest> createRepeated() => $pb.PbList<FilesListRequest>();
  @$core.pragma('dart2js:noInline')
  static FilesListRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FilesListRequest>(create);
  static FilesListRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mountId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMountId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => clearField(2);
}

class FilesListResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FilesListResponse', package: const $pb.PackageName('sirius.services'), createEmptyInstance: create)
    ..aOS(1, 'mountId')
    ..aOS(2, 'path')
    ..aOM<$1.File>(3, 'file', subBuilder: $1.File.create)
    ..aOS(4, 'region')
    ..hasRequiredFields = false
  ;

  FilesListResponse._() : super();
  factory FilesListResponse() => create();
  factory FilesListResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FilesListResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FilesListResponse clone() => FilesListResponse()..mergeFromMessage(this);
  FilesListResponse copyWith(void Function(FilesListResponse) updates) => super.copyWith((message) => updates(message as FilesListResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FilesListResponse create() => FilesListResponse._();
  FilesListResponse createEmptyInstance() => create();
  static $pb.PbList<FilesListResponse> createRepeated() => $pb.PbList<FilesListResponse>();
  @$core.pragma('dart2js:noInline')
  static FilesListResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FilesListResponse>(create);
  static FilesListResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mountId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMountId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => clearField(2);

  @$pb.TagNumber(3)
  $1.File get file => $_getN(2);
  @$pb.TagNumber(3)
  set file($1.File v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFile() => $_has(2);
  @$pb.TagNumber(3)
  void clearFile() => clearField(3);
  @$pb.TagNumber(3)
  $1.File ensureFile() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get region => $_getSZ(3);
  @$pb.TagNumber(4)
  set region($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRegion() => $_has(3);
  @$pb.TagNumber(4)
  void clearRegion() => clearField(4);
}

class FilesListRepeatedResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FilesListRepeatedResponse', package: const $pb.PackageName('sirius.services'), createEmptyInstance: create)
    ..pc<$1.File>(3, 'files', $pb.PbFieldType.PM, subBuilder: $1.File.create)
    ..hasRequiredFields = false
  ;

  FilesListRepeatedResponse._() : super();
  factory FilesListRepeatedResponse() => create();
  factory FilesListRepeatedResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FilesListRepeatedResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FilesListRepeatedResponse clone() => FilesListRepeatedResponse()..mergeFromMessage(this);
  FilesListRepeatedResponse copyWith(void Function(FilesListRepeatedResponse) updates) => super.copyWith((message) => updates(message as FilesListRepeatedResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FilesListRepeatedResponse create() => FilesListRepeatedResponse._();
  FilesListRepeatedResponse createEmptyInstance() => create();
  static $pb.PbList<FilesListRepeatedResponse> createRepeated() => $pb.PbList<FilesListRepeatedResponse>();
  @$core.pragma('dart2js:noInline')
  static FilesListRepeatedResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FilesListRepeatedResponse>(create);
  static FilesListRepeatedResponse _defaultInstance;

  @$pb.TagNumber(3)
  $core.List<$1.File> get files => $_getList(0);
}

class FileContentsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FileContentsRequest', package: const $pb.PackageName('sirius.services'), createEmptyInstance: create)
    ..aOS(1, 'mountId')
    ..aOS(2, 'path')
    ..aInt64(3, 'chunkSize')
    ..hasRequiredFields = false
  ;

  FileContentsRequest._() : super();
  factory FileContentsRequest() => create();
  factory FileContentsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileContentsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FileContentsRequest clone() => FileContentsRequest()..mergeFromMessage(this);
  FileContentsRequest copyWith(void Function(FileContentsRequest) updates) => super.copyWith((message) => updates(message as FileContentsRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FileContentsRequest create() => FileContentsRequest._();
  FileContentsRequest createEmptyInstance() => create();
  static $pb.PbList<FileContentsRequest> createRepeated() => $pb.PbList<FileContentsRequest>();
  @$core.pragma('dart2js:noInline')
  static FileContentsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileContentsRequest>(create);
  static FileContentsRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mountId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMountId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get chunkSize => $_getI64(2);
  @$pb.TagNumber(3)
  set chunkSize($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasChunkSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearChunkSize() => clearField(3);
}

class FileContentsResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FileContentsResult', package: const $pb.PackageName('sirius.services'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'bytes', $pb.PbFieldType.OY)
    ..aInt64(2, 'bytesRemaining')
    ..hasRequiredFields = false
  ;

  FileContentsResult._() : super();
  factory FileContentsResult() => create();
  factory FileContentsResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileContentsResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FileContentsResult clone() => FileContentsResult()..mergeFromMessage(this);
  FileContentsResult copyWith(void Function(FileContentsResult) updates) => super.copyWith((message) => updates(message as FileContentsResult));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FileContentsResult create() => FileContentsResult._();
  FileContentsResult createEmptyInstance() => create();
  static $pb.PbList<FileContentsResult> createRepeated() => $pb.PbList<FileContentsResult>();
  @$core.pragma('dart2js:noInline')
  static FileContentsResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileContentsResult>(create);
  static FileContentsResult _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get bytes => $_getN(0);
  @$pb.TagNumber(1)
  set bytes($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBytes() => $_has(0);
  @$pb.TagNumber(1)
  void clearBytes() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get bytesRemaining => $_getI64(1);
  @$pb.TagNumber(2)
  set bytesRemaining($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBytesRemaining() => $_has(1);
  @$pb.TagNumber(2)
  void clearBytesRemaining() => clearField(2);
}

class FileDownloadRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FileDownloadRequest', package: const $pb.PackageName('sirius.services'), createEmptyInstance: create)
    ..aOS(1, 'mountId')
    ..aOS(2, 'path')
    ..hasRequiredFields = false
  ;

  FileDownloadRequest._() : super();
  factory FileDownloadRequest() => create();
  factory FileDownloadRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileDownloadRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FileDownloadRequest clone() => FileDownloadRequest()..mergeFromMessage(this);
  FileDownloadRequest copyWith(void Function(FileDownloadRequest) updates) => super.copyWith((message) => updates(message as FileDownloadRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FileDownloadRequest create() => FileDownloadRequest._();
  FileDownloadRequest createEmptyInstance() => create();
  static $pb.PbList<FileDownloadRequest> createRepeated() => $pb.PbList<FileDownloadRequest>();
  @$core.pragma('dart2js:noInline')
  static FileDownloadRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileDownloadRequest>(create);
  static FileDownloadRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mountId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMountId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => clearField(2);
}

class FileDownloadResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FileDownloadResponse', package: const $pb.PackageName('sirius.services'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'bytes', $pb.PbFieldType.OY)
    ..aInt64(2, 'bytesRemaining')
    ..hasRequiredFields = false
  ;

  FileDownloadResponse._() : super();
  factory FileDownloadResponse() => create();
  factory FileDownloadResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileDownloadResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FileDownloadResponse clone() => FileDownloadResponse()..mergeFromMessage(this);
  FileDownloadResponse copyWith(void Function(FileDownloadResponse) updates) => super.copyWith((message) => updates(message as FileDownloadResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FileDownloadResponse create() => FileDownloadResponse._();
  FileDownloadResponse createEmptyInstance() => create();
  static $pb.PbList<FileDownloadResponse> createRepeated() => $pb.PbList<FileDownloadResponse>();
  @$core.pragma('dart2js:noInline')
  static FileDownloadResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileDownloadResponse>(create);
  static FileDownloadResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get bytes => $_getN(0);
  @$pb.TagNumber(1)
  set bytes($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBytes() => $_has(0);
  @$pb.TagNumber(1)
  void clearBytes() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get bytesRemaining => $_getI64(1);
  @$pb.TagNumber(2)
  set bytesRemaining($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBytesRemaining() => $_has(1);
  @$pb.TagNumber(2)
  void clearBytesRemaining() => clearField(2);
}

class MountsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('MountsRequest', package: const $pb.PackageName('sirius.services'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  MountsRequest._() : super();
  factory MountsRequest() => create();
  factory MountsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MountsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  MountsRequest clone() => MountsRequest()..mergeFromMessage(this);
  MountsRequest copyWith(void Function(MountsRequest) updates) => super.copyWith((message) => updates(message as MountsRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MountsRequest create() => MountsRequest._();
  MountsRequest createEmptyInstance() => create();
  static $pb.PbList<MountsRequest> createRepeated() => $pb.PbList<MountsRequest>();
  @$core.pragma('dart2js:noInline')
  static MountsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MountsRequest>(create);
  static MountsRequest _defaultInstance;
}

class MountsResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('MountsResult', package: const $pb.PackageName('sirius.services'), createEmptyInstance: create)
    ..pc<$2.Mount>(1, 'mounts', $pb.PbFieldType.PM, subBuilder: $2.Mount.create)
    ..hasRequiredFields = false
  ;

  MountsResult._() : super();
  factory MountsResult() => create();
  factory MountsResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MountsResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  MountsResult clone() => MountsResult()..mergeFromMessage(this);
  MountsResult copyWith(void Function(MountsResult) updates) => super.copyWith((message) => updates(message as MountsResult));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MountsResult create() => MountsResult._();
  MountsResult createEmptyInstance() => create();
  static $pb.PbList<MountsResult> createRepeated() => $pb.PbList<MountsResult>();
  @$core.pragma('dart2js:noInline')
  static MountsResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MountsResult>(create);
  static MountsResult _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$2.Mount> get mounts => $_getList(0);
}

class FileUploadRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FileUploadRequest', package: const $pb.PackageName('sirius.services'), createEmptyInstance: create)
    ..aInt64(3, 'chunkSize')
    ..a<$core.List<$core.int>>(4, 'bytes', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  FileUploadRequest._() : super();
  factory FileUploadRequest() => create();
  factory FileUploadRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileUploadRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FileUploadRequest clone() => FileUploadRequest()..mergeFromMessage(this);
  FileUploadRequest copyWith(void Function(FileUploadRequest) updates) => super.copyWith((message) => updates(message as FileUploadRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FileUploadRequest create() => FileUploadRequest._();
  FileUploadRequest createEmptyInstance() => create();
  static $pb.PbList<FileUploadRequest> createRepeated() => $pb.PbList<FileUploadRequest>();
  @$core.pragma('dart2js:noInline')
  static FileUploadRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileUploadRequest>(create);
  static FileUploadRequest _defaultInstance;

  @$pb.TagNumber(3)
  $fixnum.Int64 get chunkSize => $_getI64(0);
  @$pb.TagNumber(3)
  set chunkSize($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(3)
  $core.bool hasChunkSize() => $_has(0);
  @$pb.TagNumber(3)
  void clearChunkSize() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get bytes => $_getN(1);
  @$pb.TagNumber(4)
  set bytes($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(4)
  $core.bool hasBytes() => $_has(1);
  @$pb.TagNumber(4)
  void clearBytes() => clearField(4);
}

class FileUploadResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FileUploadResponse', package: const $pb.PackageName('sirius.services'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  FileUploadResponse._() : super();
  factory FileUploadResponse() => create();
  factory FileUploadResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileUploadResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FileUploadResponse clone() => FileUploadResponse()..mergeFromMessage(this);
  FileUploadResponse copyWith(void Function(FileUploadResponse) updates) => super.copyWith((message) => updates(message as FileUploadResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FileUploadResponse create() => FileUploadResponse._();
  FileUploadResponse createEmptyInstance() => create();
  static $pb.PbList<FileUploadResponse> createRepeated() => $pb.PbList<FileUploadResponse>();
  @$core.pragma('dart2js:noInline')
  static FileUploadResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileUploadResponse>(create);
  static FileUploadResponse _defaultInstance;
}

class MkDirRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('MkDirRequest', package: const $pb.PackageName('sirius.services'), createEmptyInstance: create)
    ..aOS(1, 'mountId')
    ..aOS(2, 'path')
    ..hasRequiredFields = false
  ;

  MkDirRequest._() : super();
  factory MkDirRequest() => create();
  factory MkDirRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MkDirRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  MkDirRequest clone() => MkDirRequest()..mergeFromMessage(this);
  MkDirRequest copyWith(void Function(MkDirRequest) updates) => super.copyWith((message) => updates(message as MkDirRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MkDirRequest create() => MkDirRequest._();
  MkDirRequest createEmptyInstance() => create();
  static $pb.PbList<MkDirRequest> createRepeated() => $pb.PbList<MkDirRequest>();
  @$core.pragma('dart2js:noInline')
  static MkDirRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MkDirRequest>(create);
  static MkDirRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mountId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMountId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => clearField(2);
}

class MkDirResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('MkDirResponse', package: const $pb.PackageName('sirius.services'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  MkDirResponse._() : super();
  factory MkDirResponse() => create();
  factory MkDirResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MkDirResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  MkDirResponse clone() => MkDirResponse()..mergeFromMessage(this);
  MkDirResponse copyWith(void Function(MkDirResponse) updates) => super.copyWith((message) => updates(message as MkDirResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MkDirResponse create() => MkDirResponse._();
  MkDirResponse createEmptyInstance() => create();
  static $pb.PbList<MkDirResponse> createRepeated() => $pb.PbList<MkDirResponse>();
  @$core.pragma('dart2js:noInline')
  static MkDirResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MkDirResponse>(create);
  static MkDirResponse _defaultInstance;
}

