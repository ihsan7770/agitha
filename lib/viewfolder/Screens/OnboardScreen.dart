import 'package:agitha/viewfolder/Screens/UserMainPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final PageController _controller = PageController(initialPage: 0);
  int currentIndex = 0;

  final List<Map<String, String>> slides = [
    {
      "image": "assets/boy.png",
      "Title": "Welcome to Agitha",
    },
    {
      "image": "assets/men.png",
      "Title": "Where every bite feels like home",
    },
    {
      "image": "assets/women.png",
      "Title": "Serving happiness, one meal at a time",
    },
  ];

  @override
  Widget build(BuildContext context) {
     final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: slides.length,
              onPageChanged: (int index) {
                setState(() => currentIndex = index);
              },
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      Text(
                        slides[index]['Title']!,
                        style:  GoogleFonts.tinos(
                          textStyle: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),


                      const SizedBox(height: 30),
                      Image.asset(
                        slides[index]['image']!,
                        height: 300,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              slides.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.all(4),
                width: currentIndex == index ? 14 : 8,
                height: currentIndex == index ? 14 : 8,
                decoration: BoxDecoration(
                  color: currentIndex == index ? colorScheme.primary : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

         
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Row(
              children: [
                
             
                const Spacer(),

               
                if (currentIndex == slides.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserMainPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child:  Text(
                      "Get Started",
                      style: GoogleFonts.tinos(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                    ),
                  ),

                const Spacer(),

               
              if (currentIndex < slides.length - 1)
              FloatingActionButton(
                backgroundColor: colorScheme.primary,
                onPressed: () {
                  if (currentIndex < slides.length - 1) {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                },
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
