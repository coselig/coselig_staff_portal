import 'package:flutter/material.dart';

/// 補打卡彈出視窗元件
class ManualPunchDialog extends StatefulWidget {
  final String employeeName;
  final DateTime date;
  final String? checkInTime;
  final String? checkOutTime;
  final void Function(String? checkIn, String? checkOut) onSubmit;

  const ManualPunchDialog({
    super.key,
    required this.employeeName,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    required this.onSubmit,
  });

  @override
  State<ManualPunchDialog> createState() => _ManualPunchDialogState();
}

class _ManualPunchDialogState extends State<ManualPunchDialog> {
  TimeOfDay? _checkInTime;
  TimeOfDay? _checkOutTime;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('補打卡 - ${widget.employeeName}'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('日期：${widget.date.year}/${widget.date.month}/${widget.date.day}'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Text('上班時間：${_checkInTime != null ? _checkInTime!.format(context) : (widget.checkInTime ?? '未設定')}')),
                TextButton(
                  child: const Text('選擇'),
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _checkInTime ?? TimeOfDay.now(),
                    );
                    if (picked != null) setState(() => _checkInTime = picked);
                  },
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: Text('下班時間：${_checkOutTime != null ? _checkOutTime!.format(context) : (widget.checkOutTime ?? '未設定')}')),
                TextButton(
                  child: const Text('選擇'),
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _checkOutTime ?? TimeOfDay.now(),
                    );
                    if (picked != null) setState(() => _checkOutTime = picked);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('取消'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('送出'),
          onPressed: () {
            widget.onSubmit(
              _checkInTime != null ? _checkInTime!.format(context) : widget.checkInTime,
              _checkOutTime != null ? _checkOutTime!.format(context) : widget.checkOutTime,
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
