import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// A numeric column in a [StatTable], e.g. "R" with width 34.
class StatColumn {
  const StatColumn(this.label, {this.width = 34});

  final String label;
  final double width;
}

class StatRow {
  const StatRow({
    required this.name,
    required this.values,
    this.subtitle,
    this.boldFirstValue = true,
  });

  final String name;

  /// Grey line under the name (dismissal text, "batting", ...).
  final String? subtitle;

  final List<String> values;

  /// Bolds the first numeric column (runs for batters, overs for bowlers).
  final bool boldFirstValue;
}

/// Header + rows table used for batting and bowling figures.
class StatTable extends StatelessWidget {
  const StatTable({
    super.key,
    required this.title,
    required this.columns,
    required this.rows,
  });

  final String title;
  final List<StatColumn> columns;
  final List<StatRow> rows;

  static const _batting = [
    StatColumn('R'),
    StatColumn('B'),
    StatColumn('4s', width: 30),
    StatColumn('6s', width: 30),
  ];

  static const _bowling = [
    StatColumn('O', width: 38),
    StatColumn('M', width: 30),
    StatColumn('R'),
    StatColumn('W', width: 30),
  ];

  /// Batter | R | B | 4s | 6s
  const StatTable.batting({super.key, required this.rows})
      : title = 'Batter',
        columns = _batting;

  /// Bowler | O | M | R | W
  const StatTable.bowling({super.key, required this.rows})
      : title = 'Bowler',
        columns = _bowling;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: AppColors.surfaceAlt,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            children: [
              Expanded(child: Text(title, style: _headerStyle)),
              for (final c in columns)
                SizedBox(
                  width: c.width,
                  child: Text(c.label,
                      textAlign: TextAlign.right, style: _headerStyle),
                ),
            ],
          ),
        ),
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const Divider(indent: 14, endIndent: 14),
          _buildRow(rows[i]),
        ],
      ],
    );
  }

  Widget _buildRow(StatRow row) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.name,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (row.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    row.subtitle!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
          for (var i = 0; i < columns.length; i++)
            SizedBox(
              width: columns[i].width,
              child: Text(
                row.values[i],
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: i == 0 && row.boldFirstValue
                      ? FontWeight.w700
                      : FontWeight.w400,
                ),
              ),
            ),
        ],
      ),
    );
  }

  static const _headerStyle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
  );
}
