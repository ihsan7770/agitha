import 'package:agitha/ControllersFolder/HomeViewCompanyController.dart';
import 'package:agitha/ModelsFoder/CompanyRegistrationModel.dart';
import 'package:agitha/viewfolder/Widgets/Restaurent_Card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Local_Grid_View extends StatelessWidget {
  const Local_Grid_View({super.key});

  @override
  Widget build(BuildContext context) {

        final companyProvider = Provider.of< HomeCompanyViewProvider>(context, listen: false);
    //     final List<Map<String, dynamic>> secondItems = [
    //   {
    //     "title": "BU MASOUD",
    //     "imageUrl": "assets/projectimages/mazali.jpg",
    //   },
    //   {
    //     "title": "BURGER INN",
    //     "imageUrl": "assets/projectimages/burger.jpg",
    //   },
    //   {
    //     "title": "FATAYER AL TAYER",
    //     "imageUrl": "assets/projectimages/fatahy.jpg",
    //   },
    //   {
    //     "title": "NAMLET",
    //     "imageUrl": "assets/projectimages/manus.jpg",
    //   },
    // ];
    return 
           StreamBuilder<List<CompanyRegistrationModel>>(
      stream: companyProvider.localBrandStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No Local Brand companies found"));
        }

        final companies = snapshot.data!;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          itemCount: companies.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final company = companies[index];
            //pass company data here
            return RestaurantCard(
              title: company.restaurantName,
              imageUrl: company.logoUrl,
               rating:company.rating,
              restaurantid: company.userId  ,
              location: company.location, 
              describtion: company.description,    
            );
          },
        );
      },
    );
  }
}