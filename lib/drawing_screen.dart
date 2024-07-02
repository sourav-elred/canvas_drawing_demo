import 'package:canvas_drawing_demo/drawing_painter.dart';
import 'package:flutter/material.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  DrawingScreenState createState() => DrawingScreenState();
}

class DrawingScreenState extends State<DrawingScreen> {
  List<Offset?> points = [];
  Color _selectedColor = Colors.black;
  double _strokeWidth = 4.0;

  void _clearCanvas() {
    setState(() {
      points.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canvas Drawing Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearCanvas,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  points.add(renderBox.globalToLocal(details.globalPosition));
                });
              },
              onPanEnd: (details) {
                points.add(null);
              },
              child: CustomPaint(
                painter: DrawingPainter(points, _selectedColor, _strokeWidth),
                child: Container(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildColorPicker(Colors.black),
              _buildColorPicker(Colors.red),
              _buildColorPicker(Colors.green),
              _buildColorPicker(Colors.blue),
              _buildColorPicker(Colors.yellow),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStrokeWidthPicker(4.0),
              _buildStrokeWidthPicker(8.0),
              _buildStrokeWidthPicker(12.0),
              _buildStrokeWidthPicker(16.0),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildColorPicker(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: CircleAvatar(
        backgroundColor: color,
        radius: 20,
        child: _selectedColor == color
            ? const Icon(Icons.check, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildStrokeWidthPicker(double strokeWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _strokeWidth = strokeWidth;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _strokeWidth == strokeWidth ? Colors.grey[300] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          strokeWidth.toInt().toString(),
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
