import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../main.dart';

class RewardedAdTestView extends StatefulWidget {
  const RewardedAdTestView({super.key});

  @override
  State<RewardedAdTestView> createState() => _RewardedAdTestViewState();
}

class _RewardedAdTestViewState extends State<RewardedAdTestView> {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // ✅ 테스트 ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('✅ 리워드 광고 로드 완료');
          setState(() {
            _rewardedAd = ad;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('❌ 리워드 광고 로드 실패: $error');
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      print('⚠️ 광고가 아직 로드되지 않았습니다.');
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd(); // 다시 로딩
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        print('❌ 광고 표시 실패: $error');
        _loadRewardedAd(); // 다시 로딩
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        logger.i('🎁 보상 획득: ${reward.amount} ${reward.type}');
        // 👉 TODO: 여기서 앱 내 보상 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('보상: ${reward.amount} ${reward.type}')),
        );
      },
    );

    _rewardedAd = null;
    setState(() => _isAdLoaded = false);
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('리워드 광고 테스트')),
      body: Center(
        child: ElevatedButton(
          onPressed: _isAdLoaded ? _showRewardedAd : null,
          child: const Text('🎬 리워드 광고 보기'),
        ),
      ),
    );
  }
}
