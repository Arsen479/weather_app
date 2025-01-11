import 'package:flutter/material.dart';

class WeatherInfo extends StatelessWidget {
  final String iconPath;
  final String title;
  final String value;

  const WeatherInfo(
      {super.key,
      required this.iconPath,
      required this.title,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: 70,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 163, 163),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Image.asset(iconPath, height: 70, width: 70,),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff303345),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff303345),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
