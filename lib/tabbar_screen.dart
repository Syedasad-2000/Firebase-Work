import 'package:flutter/material.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  List category = [
    "Apple",
    "One Plus",
    "Xiaomi",
    "Huawei",
    "Samsung",
  ];
  List images = [
    'images/apple.png',
    'images/oneplus.png',
    'images/Xiaomi.png',
    'images/huawei.png',
    'images/samsung.png',
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ListView.builder(
              itemCount: category.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const ScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  child: Container(
                    width: 120,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: currentIndex == index
                            ? Colors.green[300]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14)),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Text(
                      category[index],
                      style: TextStyle(
                          color: currentIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(images[currentIndex])),
            ),
          )
        ],
      ),
    );
  }
}
