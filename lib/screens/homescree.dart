import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_app/models/events.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int notification = 1;
  late Box<EventType> _eventBox;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWIdth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double statusbarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 0, 14, 0),
        child: SafeArea(
            child: Column(
          children: [
            Container(
              height: (screenHeight - statusbarHeight) * 0.10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.account_circle_outlined,
                          size: (screenHeight - statusbarHeight) * 0.05,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jane'),
                          Text('LSG Officer'),
                        ],
                      ),
                    ],
                  ),
                  CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image.asset(notification != 0
                          ? 'assets/imgs/isnotified.png'
                          : 'assets/imgs/notified.png'))
                ],
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Events',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Upcoming Events',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey.shade400,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Container(
              height: (screenHeight - statusbarHeight) * 0.40,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          decoration:
                              BoxDecoration(color: Colors.deepPurpleAccent),
                          child: Center(child: Text('Box1')),
                        )),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          decoration:
                              BoxDecoration(color: Colors.deepPurpleAccent),
                          child: Center(child: Text('Box2')),
                        )),
                        Expanded(
                            child: Container(
                          decoration:
                              BoxDecoration(color: Colors.deepPurpleAccent),
                          child: Center(child: Text('Box3')),
                        )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Event',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Summary',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey.shade400,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Container(
              decoration: BoxDecoration(color: Colors.deepPurpleAccent),
              height: (screenHeight - statusbarHeight) * 0.28,
            ),
          ],
        )),
      ),
    );
  }
}
