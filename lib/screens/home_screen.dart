import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_pinned_header/cubits/scroll_cubit.dart';
import 'package:sliver_tools/sliver_tools.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController=ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      context.read<ScrollCubit>().setOffSet(_scrollController.offset);
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor=Theme.of(context).primaryColor;
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.tightFor(
            height: max(700,MediaQuery.of(context).size.height)),
        child: SafeArea(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              //header
              Header(primaryColor: primaryColor),

              //SliverSpacer
              SliverSpacer(
                height: 5,
              ),
              //Restaurants and new and popular Section
              SliverFixedExtentList(
                  delegate: SliverChildListDelegate(
                    [
                      //Restaurant
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //restaurants
                            Restaurants(),
                            MediumTitle(title: 'Popular And New',),
                            //Popular and new item
                            PopularAndNewItems(primaryColor: primaryColor),
                          ],
                        ),
                      )
                    ]
                  ),
                  itemExtent: max(700*0.45,
                      MediaQuery.of(context).size.height*0.45)),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: MediumTitle(title: 'Categories'),
                ),
              ),

              MultiSliver(
                pushPinnedChildren: true,//if u have multiple sticky headers
                  children: [
                //categories sticky header from sliver_tools package
                Categories(primaryColor: primaryColor),
                //items
                CategoryItems(primaryColor: primaryColor),
              ])


            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItems extends StatelessWidget {
  const CategoryItems({
    super.key,
    required this.primaryColor,
  });

  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
            childCount: 20,
                (context, index){
              return Container(
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.symmetric(horizontal: 10,
                    vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      child: Image.asset('assets/img_1.jpg',
                        fit: BoxFit.cover,),
                    ),
                    Expanded(
                        child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,//shrink column main axis to fit its children
                            children: [
                              Text('Mihogo',
                                style: TextStyle(fontWeight: FontWeight.bold),),
                              SizedBox(height: 5,),
                              Text('Cum stella manducare, omnes menses magicae audax, '
                                  'neuter vigiles.Ho-ho-ho! halitosis of fortune.Yes, '
                                  'there is space, it eases with control.',
                                style: TextStyle(fontSize: 12, color: Colors.black54),),

                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  PriceCard(primaryColor: primaryColor),
                                  Icon(Icons.favorite_border, color: primaryColor,)
                                ],
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              );
            }

        ));
  }
}

class Categories extends StatelessWidget {
  const Categories({
    super.key,
    required this.primaryColor,
  });

  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return SliverPinnedHeader(
        child: BlocBuilder<ScrollCubit,double>(
          builder: (context, state){
            return Container(
              width: double.infinity,
              color: state>=400?Colors.white: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 10,),
                    CategoryTitle(title: 'LOCAL',
                      foreground: Colors.white,
                      background: primaryColor,),
                    SizedBox(width: 10,),
                    CategoryTitle(title: 'SNACKS',),
                    SizedBox(width: 10,),
                    CategoryTitle(title: 'SOUP',),
                    SizedBox(width: 10,),
                    CategoryTitle(title: 'DRINKS',),
                    SizedBox(width: 10,),
                    CategoryTitle(title: 'SHIPS',)
                  ],
                ),
              ),
            );
          },
        ));
  }
}

class CategoryTitle extends StatelessWidget {
  String title;
  Color background;
  Color foreground;
  CategoryTitle({
    super.key,
    this.foreground=Colors.black38,
    this.background=Colors.black12,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color:background,
      ),
      child: Text(title,
        style: TextStyle(color: foreground,
          fontWeight: FontWeight.bold
        ),),
    );
  }
}

class PopularAndNewItems extends StatelessWidget {
  const PopularAndNewItems({
    super.key,
    required this.primaryColor,
  });

  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex:2,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){
              return AspectRatio(
                  aspectRatio: 1.2,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset('assets/img_3.jpg',fit: BoxFit.cover,),
                    ModalBackground(),
                    Padding(
                      padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('bijumba',style: TextStyle(
                          color: Colors.white,fontWeight: FontWeight.bold
                        ),),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PriceCard(primaryColor: primaryColor),
                            Icon(Icons.favorite_border,color: primaryColor,),
                          ],
                        )
                      ],
                    ),)

                  ],
                ),
              ),);
            },
            separatorBuilder: (context,index){
              return SizedBox(width: 10,);
            },
            itemCount: 20));
  }
}

class PriceCard extends StatelessWidget {
  const PriceCard({
    super.key,
    required this.primaryColor,
  });

  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:EdgeInsets.symmetric(
        horizontal: 5,vertical: 3
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text('fc 243',style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Colors.white
      ),),
    );
  }
}

class MediumTitle extends StatelessWidget {
  String title;
  MediumTitle({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18
          ),),
        SizedBox(
          height: 6,
        )
      ],
    );
  }
}

class Restaurants extends StatelessWidget {
  const Restaurants({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
            itemBuilder: (context, index){
              return AspectRatio(
                  aspectRatio: 2/3,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Image.asset('assets/img_2.jpg',
                        fit: BoxFit.cover,
                      ),
                      ModalBackground(),
                      Center(
                        child: Text('Restaurant ${index}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),),
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context,index){
              return SizedBox(width: 10,);
            },
            itemCount: 20));
  }
}

class ModalBackground extends StatelessWidget {
  const ModalBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.4),
      width: double.infinity,
      height: double.infinity,
    );
  }
}

class SliverSpacer extends StatelessWidget {
  double height;
  double width;
  SliverSpacer({
    super.key,
    this.height=1,
    this.width=1,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: height,
        width: width,
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.primaryColor,
  });

  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/logo.png', fit: BoxFit.cover,
                  width: 70,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Gourmet Food',
                      style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),
                    ),
                    SizedBox(height: 2,),
                    Text('Get it anytime, anywhere',
                      style: TextStyle(fontSize: 12),)
                  ],
                )
              ],
            ),

            Icon(Icons.search,color: primaryColor,size: 26,),
          ],
        ),
      ),
    );
  }
}
