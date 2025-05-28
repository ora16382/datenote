enum MoodType {
  happy('😊 행복해요'),
  excited('🥳 신나요'),
  calm('🧘 차분해요'),
  tired('😪 피곤해요'),
  sad('😢 슬퍼요'),
  annoyed('😤 짜증나요'),
  angry('😡 화나요');

  final String label;
  const MoodType(this.label);
}
