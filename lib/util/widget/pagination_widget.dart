import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:datenote/util/app_color.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int page) onPageSelected;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  List<int> _buildVisiblePages() {
    const visibleCount = 3;
    final List<int> pages = [];

    if (totalPages <= visibleCount + 2) {
      return List.generate(totalPages, (i) => i + 1);
    }

    final start = (currentPage - 2).clamp(2, totalPages - visibleCount);
    final end = (start + visibleCount - 1).clamp(1, totalPages);

    pages.add(1);
    if (start > 2) pages.add(-1); // ellipsis
    pages.addAll(List.generate(end - start + 1, (i) => start + i));
    if (end < totalPages - 1) pages.add(-1); // ellipsis
    if (totalPages > 1) pages.add(totalPages);

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildVisiblePages();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: currentPage > 1 ? () => onPageSelected(currentPage - 1) : null,
        ),
        ...pages.map((page) {
          if (page == -1) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text('...'),
            );
          }
          final isSelected = page == currentPage;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () => onPageSelected(page),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  border: Border.all(color: AppColors.grey.withAlpha(100)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$page',
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: currentPage < totalPages ? () => onPageSelected(currentPage + 1) : null,
        ),
      ],
    );
  }
}
