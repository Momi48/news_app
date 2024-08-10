import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_project/models/category_news_model.dart';
import 'package:google_maps_project/models/new_channel_headlines_model.dart';
import 'package:google_maps_project/screens/category_screen.dart';
import 'package:google_maps_project/screens/details_screen.dart';
import 'package:google_maps_project/view_model/news_view_model.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final String? newsImage;
  final String? newsTitle;
  final String? newsDate;
  final String? newsAuthor;
  final String? newsDesc;
  final String? newsContent;
  final String? newsSource;

  const HomeScreen(
      {super.key,
      this.newsImage,
      this.newsTitle,
      this.newsDate,
      this.newsAuthor,
      this.newsDesc,
      this.newsContent,
      this.newsSource});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// enum FilterNewsList {
//   bbcsport,
//   arynews,
//   aljazeeraenglish,
//   bloomberg,
// }

List<String> filterlist = [
  'bbcsport',
  'arynews',
  'aljazeeraenglish',
  'cbc"',
];

String name = 'bbc-sport';

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();

  String? selected;

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('MMM,dd,yyy');
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('News',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoryScreen()));
            },
            icon: Image.asset(
              'images/category_icon.png',
              width: 20,
              height: 21,
            )),
        actions: [
          PopupMenuButton<String>(
              initialValue: selected,
              onSelected: (String item) {
                // if (FilterNewsList.bbcsport.name == item.name) {
                //   name = 'bbc-sport';
                // }
                // if (FilterNewsList.arynews.name == item.name) {
                //   name = 'ary-news';
                // }
                // if (FilterNewsList.aljazeeraenglish.name == item.name) {
                //   name = 'al-jazeera-english';
                // }
                // if (FilterNewsList.bloomberg.name == item.name) {
                //   name = 'bloomberg';
                // }
                // newsViewModel.fetchNewsChannelHeadLinesAPI(name);
                // setState(() {
                //   selected = item;
                // });
                if (filterlist[0] == item) {
                  name = 'bbc-sport';
                }
                if (filterlist[1] == item) {
                  name = 'ary-news';
                }
                if (filterlist[2] == item) {
                  name = 'al-jazeera-english';
                }
                if (filterlist[3] == item) {
                  name = 'buzzfeed';
                }
                newsViewModel.fetchNewsChannelHeadLinesAPI(name);
                setState(() {
                  selected = item;
                });
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) =>
                  // <PopupMenuEntry<FilterNewsList>>[
                  //   const PopupMenuItem<FilterNewsList>(
                  //     value: FilterNewsList.bbcsport,
                  //     child: Text('BBC-Sport'),
                  //   ),
                  //   const PopupMenuItem<FilterNewsList>(
                  //     value: FilterNewsList.arynews,
                  //     child: Text('Ary-News'),
                  //   ),
                  //   const PopupMenuItem<FilterNewsList>(
                  //     value: FilterNewsList.aljazeeraenglish,
                  //     child: Text('al-jazeera-english'),
                  //   ),
                  //   const PopupMenuItem<FilterNewsList>(
                  //     value: FilterNewsList.bloomberg,
                  //     child: Text('Bloomberg-News'),
                  //   )
                  // ]
                  <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: filterlist[0],
                      child: const Text('BBC-Sport'),
                    ),
                    PopupMenuItem<String>(
                      value: filterlist[1],
                      child: const Text('Ary-News'),
                    ),
                    PopupMenuItem<String>(
                      value: filterlist[2],
                      child: const Text('al-jazeera-english'),
                    ),
                    PopupMenuItem<String>(
                      value: filterlist[3],
                      child: const Text('buzzfeed'),
                    )
                  ])
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.55,
              width: width,
              child: FutureBuilder<NewsChannelsHeadLinesModel>(
                  future: newsViewModel.fetchNewsChannelHeadLinesAPI(name),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SpinKitCircle(
                          size: 50,
                          color: Colors.red,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text('No data available'),
                      );
                    }
        
                    if (snapshot.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.articles!.length,
                          itemBuilder: (context, index) {
                            final article = snapshot.data!.articles![index];
                            DateTime dateTime = DateTime.parse(snapshot
                                .data!.articles![index].publishedAt
                                .toString());
                            return SizedBox(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          (MaterialPageRoute(
                                              builder: (context) =>
                                                  NewsDetailScreen(
                                                      newsImage: snapshot
                                                          .data!
                                                          .articles![index]
                                                          .urlToImage
                                                          .toString(),
                                                      newsTitle: snapshot.data!.articles![index].title.toString(),
                                                      newsDate:snapshot.data!.articles![index].publishedAt.toString(),
                                                      newsAuthor: snapshot.data!.articles![index].author.toString(),
                                                      newsDesc:snapshot.data!.articles![index].description.toString(), 
                                                      newsContent: snapshot.data!.articles![index].content.toString(),
                                                      newsSource: snapshot.data!.articles![index].source!.name.toString(),
                                                      ))));
                                    },
                                    child: Container(
                                      height: height * 0.6,
                                      width: width * 0.9,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: height * 0.02),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: CachedNetworkImage(
                                          imageUrl: article.urlToImage.toString(),
                                          fit: BoxFit.cover,
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
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        height: height * 0.22,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              width: width * 0.7,
                                              child: Text(
                                                snapshot
                                                    .data!.articles![index].title
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              width: width * 0.7,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .data!
                                                        .articles![index]
                                                        .source!
                                                        .name
                                                        .toString(),
                                                  ),
                                                  Text(
                                                    format
                                                        .format(dateTime)
                                                        .toString(),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    } else {
                      return const Text('Something went wrong');
                    }
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<CatergoryNewsModel>(
                future: newsViewModel.fetchCatergoriesAPI(name),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.red,
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.articles!.length,
                          shrinkWrap: true,
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
                                        onTap: (){
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
                                                      newsTitle: snapshot.data!.articles![index2].title.toString(),
                                                      newsDate:snapshot.data!.articles![index2].publishedAt.toString(),
                                                      newsAuthor: snapshot.data!.articles![index2].author.toString(),
                                                      newsDesc:snapshot.data!.articles![index2].description.toString(), 
                                                      newsContent: snapshot.data!.articles![index2].content.toString(),
                                                      newsSource: snapshot.data!.articles![index2].source!.name.toString(),
                                                      ))));
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot
                                              .data!.articles![index2].urlToImage
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
                                        padding: const EdgeInsets.only(left: 15),
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
                                                  MainAxisAlignment.spaceBetween,
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
                          }),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
