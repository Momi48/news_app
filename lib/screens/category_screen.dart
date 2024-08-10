import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_project/models/category_news_model.dart';
import 'package:google_maps_project/repositary/news_repositary.dart';
import 'package:google_maps_project/screens/details_screen.dart';
import 'package:intl/intl.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  NewsRepositary newRep = NewsRepositary();
  List<String> categoryList = ['General', 'Tech', 'Sport', 'Entertain'];
  String category = 'general';
  int selected = 0;
  final format = DateFormat('MM dd yyyy');

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 40,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = index;

                          if (categoryList[0] == categoryList[selected]) {
                            category = 'general';
                          }
                          if (categoryList[1] == categoryList[selected]) {
                            category = 'technology';
                          }
                          if (categoryList[2] == categoryList[selected]) {
                            category = 'sport';
                          }
                          if (categoryList[3] == categoryList[selected]) {
                            category = 'entertainment';
                          }
                        });

                        newRep.fetchCatergoriesAPI(category);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 80,
                        decoration: BoxDecoration(
                          color: selected == index
                              ? Colors.blue
                              : const Color(0xff919091),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                            child: Text(
                          categoryList[index],
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: FutureBuilder<CatergoryNewsModel>(
                  future: newRep.fetchCatergoriesAPI(category),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SpinKitCircle(
                          size: 50,
                          color: Colors.red,
                        ),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data!.articles!.length,
                          itemBuilder: (context, index2) {
                            DateTime dateTime = DateTime.parse(snapshot
                                .data!.articles![index2].publishedAt
                                .toString());
                            return Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              (MaterialPageRoute(
                                                  builder: (context) =>
                                                      NewsDetailScreen(
                                                        newsImage: snapshot
                                                            .data!
                                                            .articles![index2]
                                                            .urlToImage
                                                            .toString(),
                                                        newsTitle: snapshot
                                                            .data!
                                                            .articles![index2]
                                                            .title
                                                            .toString(),
                                                        newsDate: snapshot
                                                            .data!
                                                            .articles![index2]
                                                            .publishedAt
                                                            .toString(),
                                                        newsAuthor: snapshot
                                                            .data!
                                                            .articles![index2]
                                                            .author
                                                            .toString(),
                                                        newsDesc: snapshot
                                                            .data!
                                                            .articles![index2]
                                                            .description
                                                            .toString(),
                                                        newsContent: snapshot
                                                            .data!
                                                            .articles![index2]
                                                            .content
                                                            .toString(),
                                                        newsSource: snapshot
                                                            .data!
                                                            .articles![index2]
                                                            .source!
                                                            .name
                                                            .toString(),
                                                      ))));
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data!
                                              .articles![index2].urlToImage
                                              .toString(),
                                          fit: BoxFit.cover,
                                          height: height * .18,
                                          width: width * .3,
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: SpinKitCircle(
                                              size: 50,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: height * .18,
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Column(
                                          children: [
                                            Text(
                                              snapshot
                                                  .data!.articles![index2].title
                                                  .toString(),
                                              maxLines: 3,
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    snapshot
                                                        .data!
                                                        .articles![index2]
                                                        .source!
                                                        .name
                                                        .toString(),
                                                  ),
                                                ),
                                                Text(
                                                  format.format(dateTime),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ));
                            // Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: snapshot.data!.articles![index2]
                            //                 .urlToImage !=
                            //             null
                            //         ? ListTile(
                            //             leading: Image.network(snapshot
                            //                 .data!.articles![index2].urlToImage
                            //                 .toString()),
                            //             title: Text(
                            //               snapshot.data!.articles![index2].title
                            //                   .toString(),
                            //               maxLines: 2,
                            //               overflow: TextOverflow.ellipsis,
                            //             ),
                            //             subtitle: Text(format.format(dateTime)),
                            //           )
                            //         : null
                            //         );
                          });
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
