import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Loading and Dashboard Screens',
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> data = [];
  int currentPage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'http://195.181.240.146:4444/api/v1/public/search/items?page=$currentPage&count=10'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      final List<dynamic> newData = jsonData['data'];

      setState(() {
        data.addAll(newData);
        currentPage++;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: height,
            width: width,
            child: Column(
              children: [
                const CustomAppBar(),
                SizedBox(
                  height: height * .95,
                  width: width,
                  child: ListView.builder(
                    itemCount: data.length + 1,
                    itemBuilder: (context, index) {
                      if (index == data.length) {
                        return _buildLoadingIndicator();
                      } else {
                        return _buildItemCard(data[index]);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: isLoading
          ? const SpinKitCircle(
              color: Colors.black,
              size: 75,
            )
          : const SizedBox(),
    );
  }

  Widget _buildItemCard(dynamic item) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.03, vertical: width * 0.01),
      child: InkWell(
        onTap: () {
          print('pressed');
        },
        child: Container(
          color: const Color(0xFFFFFFFF),
          child: Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'http://195.181.240.146:4444/api/v1/public/image/${item['photo']}',
                      height: width * 0.25,
                      width: width * 0.25,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    child: Container(
                      width: width * 0.2,
                      height: height * 0.03,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                        ),
                        color: Colors.green,
                      ),
                      child: const Row(
                        children: [
                          Text(
                            '⭐ 4.6 ',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          Text(
                            '(456)',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(
                  top: width * 0.08,
                  left: width * 0.02,
                ),
                height: height * 0.2,
                width: width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item['name']}',
                      style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.05,
                              color: Color(0xFF333333))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      item['description'],
                      style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.05,
                              color: Color(0xFF757575))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: width * 0.18,
                          child: Text(
                            'Start from 49rs',
                            style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.05,
                                    color: Color(0xFF333333))),
                          ),
                        ),
                        const Icon(
                          Icons.circle,
                          size: 3,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: width * 0.18,
                          child: Text(
                            '4.6Km Distance',
                            style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.05,
                                    color: Color(0xFF333333))),
                          ),
                        ),
                        const Icon(
                          Icons.circle,
                          size: 3,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: width * 0.2,
                          child: Text(
                            'Delivery in 15 min',
                            style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.05,
                                    color: Color(0xFF333333))),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          height: height * 0.02,
                          width: width * 0.2,
                          decoration: BoxDecoration(
                              color: const Color(0xFF2F80ED).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Extra discount',
                              style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.05,
                                  color: Color(0xFF2F80ED),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          height: height * 0.02,
                          width: width * 0.2,
                          decoration: BoxDecoration(
                              color: const Color(0xFFFF9213).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Extra discount',
                              style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.05,
                                  color: Color(0xFF47B275),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.05,
      width: width,
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Name ur mood...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none),
            ),
          ),
          Row(
            children: [
              const Text('|'),
              IconButton(onPressed: () {}, icon: const Icon(Icons.mic))
            ],
          )
        ],
      ),
    );
  }
}
