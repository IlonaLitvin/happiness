import 'package:api_happiness/api_happiness.dart';
import 'package:equatable/equatable.dart';

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

import 'cost/cost.dart';
import 'cost/cost_type.dart';
import 'scope_factory.dart';
import 'scope_type.dart';

// Run in the terminal for generate this file:
//    flutter pub run build_runner build --delete-conflicting-outputs
// \see https://medium.com/flutter-community/generate-the-code-to-parse-your-json-in-flutter-c68aa89a81d9
part 'scope.g.dart';

@JsonSerializable(
    ignoreUnannotated: true, includeIfNull: false, createFactory: false)
class Scope extends Equatable {
  @JsonKey(name: 'card_type')
  final CardType cardType;

  @JsonKey(name: 'card_id')
  final String cardId;

  @JsonKey()
  final List<Cost> costs;

  @JsonKey(name: 'scope')
  final ScopeType scopeType;

  bool get isFree =>
      costs.isEmpty ||
      (costs.length == 1 && costs.first.costType == CostType.get_free);

  const Scope({
    required this.cardType,
    required this.cardId,
    required this.costs,
    required this.scopeType,
  })  : assert(cardType != CardType.undefined),
        assert(cardId.length > 0),
        assert(scopeType != ScopeType.undefined);

  factory Scope.fromJson(Map<String, dynamic> jsonCard) =>
      ScopeFactory.fromJsonCard(jsonCard);

  @override
  List<Object?> get props => toJson().values.toList();

  Map<String, dynamic> toJson() => _$ScopeToJson(this);
}
