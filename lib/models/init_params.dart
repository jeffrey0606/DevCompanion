import 'package:hive/hive.dart';

part 'init_params.g.dart';

@HiveType(typeId: 4)
class InitParams extends HiveObject {
  @HiveField(0)
  bool isFirstTime;

  InitParams({
    this.isFirstTime = true,
  });
}
