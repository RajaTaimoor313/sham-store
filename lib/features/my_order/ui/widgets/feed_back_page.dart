import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shamstore/core/helpers/spacing.dart';
import 'package:flutter_shamstore/core/themina/colors.dart';
import 'package:flutter_shamstore/core/widgets/app_text_form_field.dart';
import 'package:flutter_shamstore/features/my_order/ui/widgets/confrmation_page.dart';

class FeedBackPage extends StatefulWidget {
  const FeedBackPage({super.key});

  @override
  State<FeedBackPage> createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'FeedBack',
          style: TextStyle(
            color: ColorsManager.mainBlue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // TabBar
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorsManager.mainWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: ColorsManager.mainBlue, // ✅ خط أزرق تحت النص
              indicatorWeight: 3.0, // ✅ سماكة الخط تحت الكلمة
              labelColor: ColorsManager.mainBlue, // ✅ النص الأزرق عند التحديد
              unselectedLabelColor: Colors.grey[600],
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              tabs: const [
                Tab(text: 'Review'),
                Tab(text: 'Rate'),
              ],
            ),
          ),
          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildReviewTab(), _buildRateTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Share your experience to help others and improve\n our service.',
            style: TextStyle(fontSize: 16, color: ColorsManager.mainBlack),
          ),
          verticalspace(24.h),
          AppTextFormField(
            controller: _reviewController,
            maxLines: 8,
            hintText: 'Write your review here...',
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.mainBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ConfirmationPage()),
                );
              },
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Share your experience to help others and improve\n our service.',
            style: TextStyle(fontSize: 16, color: ColorsManager.mainBlack),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: index < _rating ? Colors.amber : Colors.grey[400],
                    size: 40,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          if (_rating > 0)
            Center(
              child: Text(
                _getRatingText(_rating),
                style: TextStyle(
                  fontSize: 16,
                  color: ColorsManager.mainBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.mainBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _rating > 0
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ConfirmationPage()),
                      );
                    }
                  : null,
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }
}
