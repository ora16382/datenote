enum DateStyle {
  casual('캐주얼 / 가볍게'),
  emotional('감성적 / 분위기'),
  activity('활동적인 / 체험 중심'),
  foodie('맛집 중심'),
  unique('이색적인 / 특별한');

  final String label;
  const DateStyle(this.label);
}