import 'package:flutter/material.dart';
import 'package:news/utils/app_colors.dart';

class AppPagination extends StatelessWidget {
  final int currentPage;
  final int totalItems;
  final int itemsPerPage;
  final ValueChanged<int> onPageChanged;
  final int maxVisiblePages;

  const AppPagination({
    super.key,
    required this.currentPage,
    required this.totalItems,
    this.itemsPerPage = 10,
    required this.onPageChanged,
    this.maxVisiblePages = 4,
  });

  int get totalPages {
    int pages = (totalItems / itemsPerPage).ceil();
    // أقصى حد في خطة NewsAPI المجانية هو 10 صفحات
    if (pages > 10) pages = 10;
    return pages;
  }

  List<int> _getPageNumbers() {
    int pages = totalPages;
    if (pages <= maxVisiblePages) {
      return List.generate(pages, (i) => i + 1);
    }

    int start = currentPage - 1;
    if (start < 1) {
      start = 1;
    }
    if (start + maxVisiblePages - 1 > pages) {
      start = pages - maxVisiblePages + 1;
    }

    return List.generate(maxVisiblePages, (i) => start + i);
  }

  @override
  Widget build(BuildContext context) {
    int pages = totalPages;
    if (pages <= 1) return const SizedBox.shrink();

    final pageNumbers = _getPageNumbers();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 18),
            onPressed: currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
          ),
          ...pageNumbers.map((pageNum) {
            final isSelected = pageNum == currentPage;

            return InkWell(
              onTap: () => onPageChanged(pageNum),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : AppColors.grey,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.grey),
                ),
                child: Text(
                  "$pageNum",
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 18),
            onPressed: currentPage < pages
                ? () => onPageChanged(currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }
}
