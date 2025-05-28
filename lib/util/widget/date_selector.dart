import 'package:datenote/util/app_color.dart';
import 'package:datenote/util/functions/common_functions.dart';
import 'package:datenote/util/widget/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class DateSelector extends StatefulWidget {
  final DateTime? initialDate;
  final void Function(DateTime) onDateSelected;
  final int length;

  final Map<DateTime, Map<String, dynamic>> weatherData;

  const DateSelector({
    super.key,
    this.initialDate,
    required this.onDateSelected,
    required this.length,
    required this.weatherData,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late List<DateTime> availableDates;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    availableDates = List.generate(
      widget.length,
      (i) => now.add(Duration(days: i)),
    );
    selectedDate = widget.initialDate ?? now;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(availableDates.length, (index) {
        final date = availableDates[index];
        final isSelected = isSameDay(date, selectedDate);

        final String iconUrl =
            "https://openweathermap.org/img/wn/${(((widget.weatherData[date]?['weather'] as List?)?.firstOrNull?['icon'] ?? '') as String).replaceAll('n', 'd')}@2x.png";

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = date;
            });
            widget.onDateSelected(date);
          },
          child: Container(
            width: double.infinity,
            height: 80,
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? AppColors.primary.withAlpha(25)
                      : AppColors.grey.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.grey,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${DateFormat('yyyy.MM.dd').format(date)} (${DateFormat.E('ko').format(date)})',
                  style: Get.textTheme.headlineMedium?.copyWith(
                    color: isSelected ? Colors.pink : Colors.black87,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: buildNetworkImage(
                        imagePath: iconUrl,
                        width: 32,
                        height: 32,
                      ),
                    ),
                    Text(
                      '${(widget.weatherData[date]?['main']?['temp'] ?? '').toStringAsFixed(1)}°C',
                      style: Get.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
