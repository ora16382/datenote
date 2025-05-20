/// 데이트 플랜 추천받을떄 과정이다.
/// 1. 날짜 => 지금 현재 혹은 미래 / 시간은 설정하지 않는다.
/// 2. 주소 => 주소 목록에서 불러오거나, 검색, 현재위치
/// 3. 선호하는 타입 => 선호하는 타입 선택, 프로필에서 설정한 것도 사용함
/// 4. 날씨는 자동으로 사용됨
///
/// 5. 예산, 등등 추가할 요소는 kakao local response 를 보고 추후 고민해보자.
enum RecommendPlanStepType {
  date, address, preferredDateType
}