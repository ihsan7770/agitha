import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class DishPage_Carousel_Slider extends StatelessWidget {
  const DishPage_Carousel_Slider({super.key});

  @override
  Widget build(BuildContext context) {
    return  CarouselSlider(
              items: [
                
                //1st Image of Slider
                Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: const DecorationImage(
                      image: AssetImage("assets/projectimages/firstimg.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                //2nd Image of Slider
                Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: const DecorationImage(
                      image: AssetImage("assets/projectimages/2nd.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                //3rd Image of Slider
                Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: const DecorationImage(
                      image: AssetImage("assets/projectimages/3rd.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                //4th Image of Slider
                Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: const DecorationImage(
                      image: AssetImage("assets/projectimages/4rth.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
             
         
             
         
          ],
            
            //Slider Container properties
              options: CarouselOptions(
                height: 100.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: false,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: .50,
              ),
          );
  }
}