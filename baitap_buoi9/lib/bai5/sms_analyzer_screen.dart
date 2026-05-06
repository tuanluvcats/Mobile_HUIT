import 'package:flutter/material.dart';
import 'package:another_telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsAnalyzerScreen extends StatefulWidget {
  const SmsAnalyzerScreen({super.key});

  @override
  State<SmsAnalyzerScreen> createState() => _SmsAnalyzerScreenState();
}

class _SmsAnalyzerScreenState extends State<SmsAnalyzerScreen> {
  final Telephony telephony = Telephony.instance;
  final TextEditingController _phoneFilterController = TextEditingController();

  List<SmsMessage> _all = [];
  bool _isLoading = true;
  String _filterMode = 'ALL';
  String _phoneFilter = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final statuses = await [Permission.sms, Permission.phone].request();
    if (statuses[Permission.sms]!.isGranted) {
      await _loadMessages();
    } else {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui long cap quyen doc SMS!')),
      );
    }
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });
    final messages = await telephony.getInboxSms(
      columns: [
        SmsColumn.ADDRESS,
        SmsColumn.BODY,
        SmsColumn.DATE,
        SmsColumn.TYPE,
      ],
      sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
    );
    setState(() {
      _all = messages;
      _isLoading = false;
    });
  }

  List<SmsMessage> get _filtered {
    Iterable<SmsMessage> list = _all;
    if (_phoneFilter.isNotEmpty) {
      list = list.where((m) => (m.address ?? '').contains(_phoneFilter));
    }
    if (_filterMode == 'QC') {
      list = list.where(
        (m) => (m.body ?? '').trim().toUpperCase().startsWith('[QC]'),
      );
    } else if (_filterMode == 'OTP') {
      list = list.where((m) => _otpRegex.hasMatch(m.body ?? ''));
    }
    return list.toList();
  }

  static final RegExp _otpRegex = RegExp(r'\[OTP\]\s*\[?(\d{6})\]?');

  String? _extractOtp(String body) {
    final match = _otpRegex.firstMatch(body);
    return match?.group(1);
  }

  Map<String, int> _countByDay() {
    final Map<String, int> map = {};
    for (final m in _all) {
      if (m.date == null) continue;
      final d = DateTime.fromMillisecondsSinceEpoch(m.date!);
      final key =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      map[key] = (map[key] ?? 0) + 1;
    }
    return map;
  }

  Map<String, int> _countByMonth() {
    final Map<String, int> map = {};
    for (final m in _all) {
      if (m.date == null) continue;
      final d = DateTime.fromMillisecondsSinceEpoch(m.date!);
      final key = '${d.year}-${d.month.toString().padLeft(2, '0')}';
      map[key] = (map[key] ?? 0) + 1;
    }
    return map;
  }

  void _showOtp(String body) {
    final otp = _extractOtp(body);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ma OTP'),
        content: Text(otp ?? 'Khong tim thay OTP'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Dong'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final byDay = _countByDay();
    final byMonth = _countByMonth();

    return Scaffold(
      appBar: AppBar(title: const Text('SMS Analyzer')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tong so tin nhan: ${_all.length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Theo ngay: ${byDay.length} ngay'),
                          Text('Theo thang: ${byMonth.length} thang'),
                          const SizedBox(height: 8),
                          ExpansionTile(
                            title: const Text('Thong ke chi tiet'),
                            children: [
                              ...byMonth.entries.map(
                                (e) => ListTile(
                                  dense: true,
                                  title: Text('Thang ${e.key}'),
                                  trailing: Text('${e.value} tin'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _phoneFilterController,
                    decoration: const InputDecoration(
                      labelText: 'Loc theo so dien thoai',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _phoneFilter = val.trim();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Tat ca'),
                      selected: _filterMode == 'ALL',
                      onSelected: (_) => setState(() => _filterMode = 'ALL'),
                    ),
                    ChoiceChip(
                      label: const Text('Quang cao'),
                      selected: _filterMode == 'QC',
                      onSelected: (_) => setState(() => _filterMode = 'QC'),
                    ),
                    ChoiceChip(
                      label: const Text('OTP'),
                      selected: _filterMode == 'OTP',
                      onSelected: (_) => setState(() => _filterMode = 'OTP'),
                    ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: _filtered.isEmpty
                      ? const Center(child: Text('Khong co tin nhan.'))
                      : ListView.builder(
                          itemCount: _filtered.length,
                          itemBuilder: (context, index) {
                            final m = _filtered[index];
                            final isOtp = _otpRegex.hasMatch(m.body ?? '');
                            return ListTile(
                              leading: Icon(
                                isOtp
                                    ? Icons.vpn_key
                                    : (m.body ?? '').startsWith('[QC]')
                                    ? Icons.campaign
                                    : Icons.message,
                              ),
                              title: Text(
                                m.body ?? 'Khong co noi dung',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text('Tu: ${m.address ?? 'Khong ro'}'),
                              onTap: isOtp ? () => _showOtp(m.body!) : null,
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
