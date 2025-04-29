import 'package:get/get_utils/src/extensions/internacionalization.dart';

enum Gender {
  male('남자'),
  female('여자');

  final String label;

  const Gender(this.label);
}

extension TitleExtension on Gender {
  String get getIcon {
    switch (this) {
      case Gender.female:
        return 'assets/images/icon/female.png';
      case Gender.male:
        return 'assets/images/icon/male.png';
    }
  }
}
