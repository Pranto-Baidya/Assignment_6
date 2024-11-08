import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskSummaryCard extends StatefulWidget {
  const TaskSummaryCard({
    super.key, required this.count, required this.title, required this.color, required this.textColor,
  });

  final int count;
  final String title;
  final Color color;
  final Color textColor;

  @override
  State<TaskSummaryCard> createState() => _TaskSummaryCardState();
}

class _TaskSummaryCardState extends State<TaskSummaryCard> {

  bool RefreshCount = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(

      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: widget.color,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${widget.count}',style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: widget.textColor,
                  fontSize: 65
              ),
              ),

              Text(widget.title,style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: widget.textColor,
                  fontSize: 16
              )),
            ],
          ),
        ),
      ),
    );
  }
}