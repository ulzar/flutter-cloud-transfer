///
//  Generated code. Do not modify.
//  source: sirius/types/mount.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Mount extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Mount', package: const $pb.PackageName('sirius.types'), createEmptyInstance: create)
    ..aOS(1, 'id')
    ..aOS(2, 'name')
    ..aOS(3, 'mountLocation')
    ..aOS(4, 'groupId')
    ..hasRequiredFields = false
  ;

  Mount._() : super();
  factory Mount() => create();
  factory Mount.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Mount.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Mount clone() => Mount()..mergeFromMessage(this);
  Mount copyWith(void Function(Mount) updates) => super.copyWith((message) => updates(message as Mount));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Mount create() => Mount._();
  Mount createEmptyInstance() => create();
  static $pb.PbList<Mount> createRepeated() => $pb.PbList<Mount>();
  @$core.pragma('dart2js:noInline')
  static Mount getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Mount>(create);
  static Mount _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get mountLocation => $_getSZ(2);
  @$pb.TagNumber(3)
  set mountLocation($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMountLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearMountLocation() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get groupId => $_getSZ(3);
  @$pb.TagNumber(4)
  set groupId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasGroupId() => $_has(3);
  @$pb.TagNumber(4)
  void clearGroupId() => clearField(4);
}

