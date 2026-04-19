import 'package:flutter/material.dart';
import 'color_display.dart';
import '../screens/profile_page.dart';


class ColorChooser extends StatefulWidget {
  @override
  _ColorChooserState createState() => _ColorChooserState();
}

class _ColorChooserState extends State<ColorChooser> {
  Color selectedColor = Colors.red;

  void changeColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Color Chooser")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Choose a color:"),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => changeColor(Colors.red),
                  child: Text("Red"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () => changeColor(Colors.green),
                  child: Text("Green"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () => changeColor(Colors.blue),
                  child: Text("Blue"),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ColorDisplay(color: selectedColor),
                  ),
                );
              },
              child: Text("Go to Display Screen"),
            ),
            
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, '/');
              },
              child: 
              Text("Click em"),
            ),

            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage())
                );
              },
              child:
              Text("Click em"),
            ),

          ],
        ),
      ),
    );
  }
}