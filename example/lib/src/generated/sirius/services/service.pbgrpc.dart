///
//  Generated code. Do not modify.
//  source: sirius/services/service.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'service.pb.dart' as $0;
export 'service.pb.dart';

class SiriusClient extends $grpc.Client {
  static final _$mounts = $grpc.ClientMethod<$0.MountsRequest, $0.MountsResult>(
      '/sirius.services.Sirius/Mounts',
      ($0.MountsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MountsResult.fromBuffer(value));
  static final _$filesList =
      $grpc.ClientMethod<$0.FilesListRequest, $0.FilesListResponse>(
          '/sirius.services.Sirius/FilesList',
          ($0.FilesListRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.FilesListResponse.fromBuffer(value));
  static final _$fileContents =
      $grpc.ClientMethod<$0.FileContentsRequest, $0.FileContentsResult>(
          '/sirius.services.Sirius/FileContents',
          ($0.FileContentsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.FileContentsResult.fromBuffer(value));
  static final _$fileDownload =
      $grpc.ClientMethod<$0.FileDownloadRequest, $0.FileDownloadResponse>(
          '/sirius.services.Sirius/FileDownload',
          ($0.FileDownloadRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.FileDownloadResponse.fromBuffer(value));
  static final _$fileUpload =
      $grpc.ClientMethod<$0.FileUploadRequest, $0.FileUploadResponse>(
          '/sirius.services.Sirius/FileUpload',
          ($0.FileUploadRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.FileUploadResponse.fromBuffer(value));
  static final _$fileUploadV2 =
      $grpc.ClientMethod<$0.FileUploadRequest, $0.FileUploadResponse>(
          '/sirius.services.Sirius/FileUploadV2',
          ($0.FileUploadRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.FileUploadResponse.fromBuffer(value));
  static final _$mkDir = $grpc.ClientMethod<$0.MkDirRequest, $0.MkDirResponse>(
      '/sirius.services.Sirius/MkDir',
      ($0.MkDirRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MkDirResponse.fromBuffer(value));

  SiriusClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.MountsResult> mounts($0.MountsRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$mounts, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseStream<$0.FilesListResponse> filesList(
      $0.FilesListRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$filesList, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseStream(call);
  }

  $grpc.ResponseStream<$0.FileContentsResult> fileContents(
      $0.FileContentsRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$fileContents, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseStream(call);
  }

  $grpc.ResponseStream<$0.FileDownloadResponse> fileDownload(
      $async.Stream<$0.FileDownloadRequest> request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$fileDownload, request, options: options);
    return $grpc.ResponseStream(call);
  }

  $grpc.ResponseFuture<$0.FileUploadResponse> fileUpload(
      $async.Stream<$0.FileUploadRequest> request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$fileUpload, request, options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseStream<$0.FileUploadResponse> fileUploadV2(
      $async.Stream<$0.FileUploadRequest> request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$fileUploadV2, request, options: options);
    return $grpc.ResponseStream(call);
  }

  $grpc.ResponseFuture<$0.MkDirResponse> mkDir($0.MkDirRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$mkDir, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class SiriusServiceBase extends $grpc.Service {
  $core.String get $name => 'sirius.services.Sirius';

  SiriusServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.MountsRequest, $0.MountsResult>(
        'Mounts',
        mounts_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.MountsRequest.fromBuffer(value),
        ($0.MountsResult value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FilesListRequest, $0.FilesListResponse>(
        'FilesList',
        filesList_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.FilesListRequest.fromBuffer(value),
        ($0.FilesListResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.FileContentsRequest, $0.FileContentsResult>(
            'FileContents',
            fileContents_Pre,
            false,
            true,
            ($core.List<$core.int> value) =>
                $0.FileContentsRequest.fromBuffer(value),
            ($0.FileContentsResult value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.FileDownloadRequest, $0.FileDownloadResponse>(
            'FileDownload',
            fileDownload,
            true,
            true,
            ($core.List<$core.int> value) =>
                $0.FileDownloadRequest.fromBuffer(value),
            ($0.FileDownloadResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FileUploadRequest, $0.FileUploadResponse>(
        'FileUpload',
        fileUpload,
        true,
        false,
        ($core.List<$core.int> value) => $0.FileUploadRequest.fromBuffer(value),
        ($0.FileUploadResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FileUploadRequest, $0.FileUploadResponse>(
        'FileUploadV2',
        fileUploadV2,
        true,
        true,
        ($core.List<$core.int> value) => $0.FileUploadRequest.fromBuffer(value),
        ($0.FileUploadResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MkDirRequest, $0.MkDirResponse>(
        'MkDir',
        mkDir_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.MkDirRequest.fromBuffer(value),
        ($0.MkDirResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.MountsResult> mounts_Pre(
      $grpc.ServiceCall call, $async.Future<$0.MountsRequest> request) async {
    return mounts(call, await request);
  }

  $async.Stream<$0.FilesListResponse> filesList_Pre($grpc.ServiceCall call,
      $async.Future<$0.FilesListRequest> request) async* {
    yield* filesList(call, await request);
  }

  $async.Stream<$0.FileContentsResult> fileContents_Pre($grpc.ServiceCall call,
      $async.Future<$0.FileContentsRequest> request) async* {
    yield* fileContents(call, await request);
  }

  $async.Future<$0.MkDirResponse> mkDir_Pre(
      $grpc.ServiceCall call, $async.Future<$0.MkDirRequest> request) async {
    return mkDir(call, await request);
  }

  $async.Future<$0.MountsResult> mounts(
      $grpc.ServiceCall call, $0.MountsRequest request);
  $async.Stream<$0.FilesListResponse> filesList(
      $grpc.ServiceCall call, $0.FilesListRequest request);
  $async.Stream<$0.FileContentsResult> fileContents(
      $grpc.ServiceCall call, $0.FileContentsRequest request);
  $async.Stream<$0.FileDownloadResponse> fileDownload(
      $grpc.ServiceCall call, $async.Stream<$0.FileDownloadRequest> request);
  $async.Future<$0.FileUploadResponse> fileUpload(
      $grpc.ServiceCall call, $async.Stream<$0.FileUploadRequest> request);
  $async.Stream<$0.FileUploadResponse> fileUploadV2(
      $grpc.ServiceCall call, $async.Stream<$0.FileUploadRequest> request);
  $async.Future<$0.MkDirResponse> mkDir(
      $grpc.ServiceCall call, $0.MkDirRequest request);
}
