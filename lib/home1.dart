import 'dart:io';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:myeyes1/widgets/customTag.dart';

import 'package:url_launcher/url_launcher_string.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage1> {
  //late FirebaseStorage storage;
  late String imageUrl = '';
  String _locationMessage = "";
  final Location _location = Location();
  @override
  void initState() {
    //storage = FirebaseStorage.instance;
    super.initState();

    _requestPermission();
  }

  /*Future<File> _downloadImage(String url) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String fileName = url.split('/').last;
    File file = File('$tempPath/$fileName');
    if (file.existsSync()) {
      return file;
    }
    //final ref = storage.refFromURL(url);
    //await ref.writeToFile(file);
    return file;
  }*/

  void _seePhotos() async {
    /*
    String url = "gs://pfeapp-bc690.appspot.com/SELOGO.jpg";
    File file = await _downloadImage(url);

    setState(() {
      imageUrl = file.path;
    });*/
  }

  Future<void> _requestPermission() async {
    var permission = await _location.requestPermission();
    if (permission == PermissionStatus.granted) {
      _getLocation();
    }
  }

  Future<void> _getLocation() async {
    try {
      var currentLocation = await _location.getLocation();
      setState(() {
        _locationMessage =
            "Latitude: ${currentLocation.latitude}, Longitude: ${currentLocation.longitude}";
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _openMap() async {
    var currentLocation = await _location.getLocation();
    var url =
        "https://www.google.com/maps/search/?api=1&query=${currentLocation.latitude},${currentLocation.longitude}";
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  int _selectedIndex = 0;
  List<Widget> _pages = [];

  @override
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    /* Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
    print('Logout');*/
  }

  @override
  Widget build(BuildContext context) {
    _pages = [
      const PageWithText('Home'),
      PageWithButton(_locationMessage, 'Open Map', _openMap, ''),
      PageWithButton('Photos', 'See Photos', _seePhotos, imageUrl),
      PageWithButton('About Us', '', _logout, ''),
    ];
    return Scaffold(
      backgroundColor: const Color.fromRGBO(194, 91, 78, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(194, 91, 78, 1.0),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('My Eyes'),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.logout, color: Color.fromARGB(255, 10, 9, 0)),
            onPressed: _logout,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.location_on),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.photo_album),
            label: 'Photos',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.person),
            label: 'About Us',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class PageWithButton extends StatelessWidget {
  final String title;
  final String buttonLabel;
  final VoidCallback buttonFunction;
  final String imageUrl;

  const PageWithButton(
      this.title, this.buttonLabel, this.buttonFunction, this.imageUrl,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title),
          if (buttonLabel
              .isNotEmpty) // Show the button if the label is not empty
            ElevatedButton(
              onPressed: buttonFunction,
              child: Text(buttonLabel),
            ),
          if (buttonLabel.isEmpty)
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.6,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(194, 91, 78, 1.0),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(70),
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        "images/home.png",
                        scale: 0.8,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.666,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(70),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'More information about US!',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              wordSpacing: 2,
                              color: Color.fromRGBO(24, 24, 32, 1),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40)),
                          Text(
                            "our mobile application by Se Engineering, designed to assist visually impaired individuals in navigating their surroundings with ease. My app offers a unique and innovative feature that not only helps users locate their current position but also allows them to revisit the last photos they saw. Using advanced GPS technology, the app provides audio cues to guide users to their desired destination. Additionally, users can take pictures of their surroundings and save them for future reference. This feature is particularly helpful for those who may want to revisit a specific location or landmark. My app also provides audio descriptions of the photos, making it easier for visually impaired users to recall and identify the objects captured in the image. As the creator of this app, I am proud to offer a tool that utilizes technology to improve the lives of visually impaired individuals and enhance their independence.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              color: Color.fromRGBO(24, 24, 32, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (imageUrl.isNotEmpty) // Show the image if the URL is not empty
            Image.file(
              File(imageUrl),
              height: 200,
            ),
        ],
      ),
    );
  }
}

class PageWithText extends StatefulWidget {
  final String title;
  const PageWithText(this.title, {super.key});

  @override
  State<PageWithText> createState() => _PageWithTextState();
}

class _PageWithTextState extends State<PageWithText> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(0),
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 150,
              child: RichText(
                  text: const TextSpan(
                      text: 'Welcome',
                      style: TextStyle(
                        fontSize: 32,
                        color: Color.fromRGBO(246, 246, 246, 1),
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                    TextSpan(
                        text: ' to My Eyes!',
                        style: TextStyle(
                          color: Colors.black87,
                        ))
                  ])),
            ),
            ImageContainer(
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20.0),
              image: 'assets/images/image.png',
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'We are excited to have you here. we hope you enjoy your experience with our app. Thanks for choosing My Eyes!',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                  ),
                  Text(
                    'By SE Engineering',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    super.key,
    this.height = 125,
    this.borderRadius = 20,
    required this.width,
    required this.image,
    this.padding,
    this.margin,
    this.child,
  });
  final double width;
  final double height;
  final String image;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: width,
      margin: margin,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          )),
      child: child,
    );
  }
}
