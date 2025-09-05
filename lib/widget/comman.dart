import 'package:flutter/material.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coming Soon'),
        backgroundColor: Colors.yellow[400],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'COMING SOON!',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                "We're currently working on creating our new website. We'll be launching soon, subscribe to be notified.",
                style: TextStyle(fontSize: 18.0, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Image.asset('assets/bob_the_builder.png', height: 150),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  print('Notify Me clicked!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[600],
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'NOTIFY ME',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
