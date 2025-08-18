import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // ===== HEADER CARD =====
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 50),

            // ===== Transactions Title =====
            Container(
              width: 180,
              height: 20,
              color: Colors.white,
            ),
            const SizedBox(height: 16),

            // ===== Transactions List =====
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    // Circle icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Text placeholders
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 100,
                            height: 12,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Amount placeholder
                    Container(
                      width: 60,
                      height: 14,
                      color: Colors.white,
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
