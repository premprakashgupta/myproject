import 'package:flutter/material.dart';


class LanguageScreen extends StatelessWidget {
  LanguageScreen({Key? key}) : super(key: key);

  // Dummy data for grid items
  final List<Map<String, dynamic>> gridItems = [
    {
      'image': 'assets/images/statue_of_unity.jpg',
      'color': Colors.red,
      'text': 'Hindi',
    },
    {
      'image': 'assets/images/statue_of_liberty.png',
      'color': Colors.blue,
      'text': 'English',
    },
    {
      'image': 'assets/images/statue_of_liberty.png',
      'color': Colors.green,
      'text': 'Gujrati',
    },

    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.amberAccent,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          child: Column(
            children: [
              const Text(
                "Select Language : ",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 34,
                    mainAxisSpacing: 34,
                  ),
                  itemCount: gridItems.length,
                  itemBuilder: (context, index) {
                    return GridItem(
                      image: gridItems[index]['image'],
                      color: gridItems[index]['color'],
                      text: gridItems[index]['text'],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final String image;
  final Color color;
  final String text;

  const GridItem({super.key, 
    required this.image,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(4, 4),
          ),
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(-4, -4),
          ),
        ],
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(.6),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
