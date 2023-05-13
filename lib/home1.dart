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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 21, 4, 34),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('My Eyes'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Color.fromARGB(255, 10, 9, 0)),
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
          if (buttonLabel.isEmpty) // Show the text if the label is empty
            Container(
              padding: const EdgeInsets.all(0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.6,
                    decoration: BoxDecoration(
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
                ],
              ),
            )
          else // Show the image if the URL is not empty
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
                        color: Color.fromRGBO(194, 91, 78, 1.0),
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
              width: double.infinity,
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

class Qui extends StatelessWidget {
  const Qui({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Text(
            'Hello!',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  height: 3,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Our app provides support services for the visually impaired.\n It features real-time location tracking and can capture and transfer the last photo taken by smart glasses, benefiting those with partial vision.\n Our goal is to empower people with visual impairments for greater independence in daily activities.',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 2.25,
                ),
          ),
        ],
      ),
    );
  }
}

class Intro extends StatelessWidget {
  const Intro({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ImageContainer(
        height: MediaQuery.of(context).size.height * 0.45,
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        image: 'assets/images/image.png',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTag(
              backgroundColor:
                  const Color.fromARGB(255, 197, 189, 231).withAlpha(150),
              children: [
                Text(
                  'Welcome to My Eyes! ',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: const Color.fromARGB(255, 241, 240, 245),
                      ),
                ),
              ],
            ),
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
        ));
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
