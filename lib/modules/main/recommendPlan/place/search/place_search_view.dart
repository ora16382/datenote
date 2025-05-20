import 'package:datenote/main.dart';
import 'package:datenote/modules/main/recommendPlan/place/search/place_search_controller.dart';
import 'package:datenote/util/widget/common_widget.dart';
import 'package:datenote/util/widget/pagination_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:datenote/util/app_color.dart';

class PlaceSearchView extends StatefulWidget {
  const PlaceSearchView({super.key});

  @override
  State<PlaceSearchView> createState() => _PlaceSearchViewState();
}

class _PlaceSearchViewState extends State<PlaceSearchView> {
  final ctrl = Get.put(PlaceSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('장소 검색', style: Get.textTheme.titleMedium),
        centerTitle: true,
        elevation: 0,
        leading: buildBackBtn(() => Get.back(),),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [_buildSearchBar(), _buildSearchResults(), _buildPagination()]),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autofocus: true,
              controller: ctrl.searchController,
              decoration: InputDecoration(
                hintText: '장소를 입력하세요',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: (_) => ctrl.onSearch(),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(left: 8),
            height: 48,
            child: ElevatedButton(
              onPressed: ctrl.onSearch,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Icon(Icons.search, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Expanded(
      child: GetBuilder<PlaceSearchController>(
        id: ':searchResult',
        builder: (_) {
          if (ctrl.isInit) {
            return Center(child: Text('데이트 플랜에 추가하고 싶은 장소를 찾아보세요.', style: Get.textTheme.bodyLarge));
          } else if (ctrl.isLoading) {
            return Center(child: SpinKitFadingCircle(color: AppColors.primary, size: 50.0));
          } else if (ctrl.placeListMap.isEmpty) {
            return Center(child: Text('검색 결과가 없습니다.', style: Get.textTheme.bodyLarge));
          } else {
            return ListView.builder(
              itemCount: ctrl.placeListMap[ctrl.currentPage]?.length,
              itemBuilder: (context, index) {
                final place = ctrl.placeListMap[ctrl.currentPage]![index];

                return ListTile(
                  title: Text(place.place_name),
                  subtitle: Text(place.address_name),
                  onTap: () => ctrl.onSelectPlace(place),
                  trailing: const Icon(Icons.chevron_right),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: GetBuilder<PlaceSearchController>(
        id: ':pagination',
        builder: (context) {
          if (ctrl.isInit || ctrl.isLoading || ctrl.placeListMap.isEmpty) {
            return SizedBox.shrink();
          } else {
            return PaginationWidget(
              currentPage: ctrl.currentPage,
              totalPages: ctrl.totalPages,
              onPageSelected: ctrl.onPageSelected,
            );
          }
        },
      ),
    );
  }
}
