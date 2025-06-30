import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minimal_parkinglot/core/theme/app_pallete.dart';
import 'package:minimal_parkinglot/features/home/model/parkinglot_model.dart';
import 'package:minimal_parkinglot/features/home/view/pages/checkin_page.dart';
import 'package:minimal_parkinglot/features/home/view/pages/checkout_page.dart';
import 'package:minimal_parkinglot/features/home/view/widgets/action_button.dart';
import 'package:minimal_parkinglot/features/home/view/widgets/activity_item.dart';
import 'package:minimal_parkinglot/features/home/view/widgets/stat_item.dart';

class ParkinglotPage extends StatelessWidget {
  final ParkinglotModel parkinglot;

  const ParkinglotPage({super.key, required this.parkinglot});

  @override
  Widget build(BuildContext context) {
    print(parkinglot);
    final int availableSpaces = parkinglot.maxSpaces - parkinglot.currentSpaces;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(parkinglot.name, style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Stats Cards
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Pallete.gradient1.withOpacity(0.8),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildStatItem(
                    'Tổng chỗ',
                    '${parkinglot.maxSpaces}',
                    Icons.local_parking,
                  ),
                  buildStatItem(
                    'Đang sử dụng',
                    '${parkinglot.currentSpaces}',
                    Icons.motorcycle_outlined,
                  ),
                  buildStatItem(
                    'Còn trống',
                    '$availableSpaces',
                    Icons.check_circle,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: buildActionButton(
                    context,
                    'Check In',
                    Icons.login,
                    Color(0xFF4CAF50),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  CheckInPage(parkinglotId: parkinglot.id),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: buildActionButton(
                    context,
                    'Check Out',
                    Icons.logout,
                    Color(0xFFFF5722),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckOutPage()),
                      );
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),

            // Recent Activity
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hoạt động gần đây',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return buildActivityItem();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
