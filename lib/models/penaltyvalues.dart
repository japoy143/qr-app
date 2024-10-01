import 'package:hive_flutter/adapters.dart';

part 'penaltyvalues.g.dart';

@HiveType(typeId: 6)
class PenaltyValues {
  @HiveField(0)
  int id;
  @HiveField(1)
  String penaltyvalue;
  @HiveField(2)
  int penaltyprice;
  @HiveField(3)
  bool isOpen;

  PenaltyValues(
      {required this.id,
      required this.penaltyvalue,
      required this.penaltyprice,
      required this.isOpen});
}
