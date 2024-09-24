import 'package:flutter/material.dart';
import 'package:web_test/model/result/model.dart';
import 'package:web_test/service/result.dart';
import 'package:web_test/ui/admin/widget/drawer.dart';
import 'package:web_test/ui/admin/widget/point_spectrum.dart';
import 'package:web_test/ui/admin/widget/result.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final resService = ResultService();
  List<ResultModel> results = [];
  @override
  void initState() {
    resService.getAllResult().then((value) {
      results = value;
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Masan\'s Test | Admin',
      color: Theme.of(context).primaryColor,
      child: Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdminDrawer(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TestResultWidget(
                        results: results,
                      ),
                      const Divider(
                        color: Colors.black,
                        height: 40,
                      ),
                      PointSpectrumWidget(results: results),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
