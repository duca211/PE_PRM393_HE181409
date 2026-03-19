import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Center(child: Text("About me")),
        ),
        body: AboutBody(),
      ),
    );
  }
}

class AboutImage extends StatelessWidget {
  const AboutImage({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Image.asset("assets/images/avatar7.jpg", fit: BoxFit.fill),
    );
  }
}

class AboutContent extends StatelessWidget {
  const AboutContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      right: 20,
      left: 20,
      child: Container(
        height: 200,
        width: double.infinity,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "About me",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.red,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  textAlign: TextAlign.justify,
                  "The slogan is short, memorable, and versatile, suitable for use across multiple touchpoints, app interface...",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutBody extends StatelessWidget {
  const AboutBody({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(children: [AboutImage(), AboutContent()]);
  }
}
