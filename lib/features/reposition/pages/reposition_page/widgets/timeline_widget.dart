import 'package:flutter/material.dart';

class MyTimeLine extends StatefulWidget {
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<MyTimeLine> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: <Widget>[
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Wrap(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Container(
                      width: 30.0,
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 4.0),
                                  height: double.infinity,
                                  width: 1.0,
                                  color: Colors.deepOrange),
                            ),
                            Container(
                              padding: EdgeInsets.only(),
                              child: Icon(Icons.star, color: Colors.white),
                              decoration: BoxDecoration(
                                  color: Color(0xff00c6ff),
                                  shape: BoxShape.circle),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 5.0),
                      child: Text(
                        'Header Text',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.deepOrange,
                            fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, top: 5.0),
                      child: Text(
                          'Lorem ipsum description here description here Lorem ipsum description here description here Lorem ipsum description here Lorem ipsum description here description here Lorem ipsum description here description here Lorem ipsum description here description here Lorem ipsum description here description here Lorem ipsum description here description here Lorem ipsum description here description here Lorem ipsum description here description here Lorem ipsum description here description here Lorem ipsum description here description here Lorem ipsum description here description here '),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
