enum PreferredDateType {
  chillCafeDate('☕ 감성 카페 데이트'),
  gourmetTourDate('🍽 맛집 탐방 데이트'),
  culturalDate('🎭 전시·공연 문화 데이트'),
  activeDate('🎯 활동적인 체험 데이트'),
  healingDate('🌿 산책·힐링 데이트');

  final String label;

  const PreferredDateType(this.label);
}