import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final DocumentSnapshot? note;

  NoteDetail({this.note});

  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Color _selectedColor = Colors.white;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!['title'];
      _contentController.text = widget.note!['content'];
      _selectedColor = Color(widget.note!['color'] ?? Colors.white.value);
    }
  }

  void _saveNote() async {
    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
      final noteData = {
        'title': _titleController.text,
        'content': _contentController.text,
        'date': DateFormat.yMMMd().format(DateTime.now()),
        'color': _selectedColor.value,
      };

      if (widget.note != null) {
        await _firestore.collection('notes').doc(widget.note!.id).update(noteData);
      } else {
        await _firestore.collection('notes').add(noteData);
      }

      Navigator.of(context).pop();
    }
  }

  void _deleteNote() async {
    if (widget.note != null) {
      await _firestore.collection('notes').doc(widget.note!.id).delete();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteNote,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(hintText: 'Content'),
              maxLines: 10,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Note Color:'),
                SizedBox(width: 16),
                ..._buildColorOptions(),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildColorOptions() {
    final colors = [
      Colors.white,
      Colors.red.shade100,
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.yellow.shade100,
    ];

    return colors.map((color) {
      return GestureDetector(
        onTap: () => setState(() => _selectedColor = color),
        child: Container(
          width: 30,
          height: 30,
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: color,
            border: _selectedColor == color
                ? Border.all(color: Colors.black, width: 2)
                : null,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    }).toList();
  }
}