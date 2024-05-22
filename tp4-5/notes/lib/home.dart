import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes/details.dart';

class Note {
  int id;
  String content;
  DateTime date;

  Note({
    required this.id,
    required this.content,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'date': date.toString(),
    };
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  List<Note> _notes = [];
  Note? _selectedNote;
  Database? _database;

  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _initDatabase().then((_) {
      setState(() {}); // Call setState to rebuild the widget tree
    });
  }

  Future<void> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + 'notes.db';
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
        CREATE TABLE notes (
          id INTEGER PRIMARY KEY,
          content TEXT NOT NULL,
          date TEXT NOT NULL
        )
      ''');
        });
    _notes = await _getAllNotes();
  }

  Future<List<Note>> _getAllNotes() async {
    final List<Map<String, dynamic>> maps = await _database!.query('notes');
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        content: maps[i]['content'],
        date: DateTime.parse(maps[i]['date']),
      );
    });
  }

  void _addNote() async {
    String noteContent = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Note'),
          content: TextField(
            onChanged: (value) {
              noteContent = value;
            },
            decoration: InputDecoration(hintText: 'Enter your note'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (noteContent.isNotEmpty) {
                  _insertNote(noteContent);
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _insertNote(String content) async {
    await _database!.insert(
      'notes',
      Note(id: DateTime.now().millisecondsSinceEpoch, content: content, date: DateTime.now()).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    setState(() {
      _notes.add(Note(id: DateTime.now().millisecondsSinceEpoch, content: content, date: DateTime.now()));
    });
  }

  void _viewNoteDetails(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetails(
          content: note.content,
          date: note.date,
        ),
      ),
    );
  }

  void _viewNoteDetails2(Note note) {
    setState(() {
      _selectedNote = note;
    });
  }

  void _confirmDelete(BuildContext context, int id) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this note?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await _database!.delete(
                  'notes',
                  where: 'id =?',
                  whereArgs: [id],
                );
                setState(() {
                  _notes.removeWhere((note) => note.id == id);
                  _selectedNote = null;
                });
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: Color.fromARGB(255, 213, 222, 32),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildNoteList2(),
                ),
                Expanded(
                  flex: 1,
                  child: _buildNoteDetails(),
                ),
              ],
            );
          } else {
            return _buildNoteList();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildNoteList() {
    if (_notes.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _viewNoteDetails(_notes[index]),
            onLongPress: () => _confirmDelete(context, _notes[index].id),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    leading: Image.asset(
                      'assets/images/logo.png',
                      width: 50, // Adjust as needed
                      height: 50, // Adjust as needed
                    ),
                    title: Text(
                      '',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      _notes[index].content,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey[400]),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildNoteList2() {
    if (_notes.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _viewNoteDetails2(_notes[index]),
            onLongPress: () => _confirmDelete(context, _notes[index].id),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    leading: Image.asset(
                      'assets/images/logo.png',
                      width: 50, // Adjust as needed
                      height: 50, // Adjust as needed
                    ),
                    title: Text(
                      'Note',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      _notes[index].content,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey[400]),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildNoteDetails() {
    final DateFormat formatter = DateFormat('MMM dd, yyyy HH:mm'); // Define date format
    return Container(
      padding: EdgeInsets.all(16.0),
      child: _selectedNote == null
          ? Center(child: Text('No note selected'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 50, // Adjust as needed
                  height: 50, // Adjust as needed
                ),

                SizedBox(height: 16.0),
                Text(
                  _selectedNote!.content,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Created: ${formatter.format(_selectedNote!.date)}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    speak(_selectedNote!.content);
                  },
                  child: Text('Read Aloud'),
                ),
                ElevatedButton(
                  onPressed: () {
                    stop();
                  },
                  child: Text('stop'),
                ),
              ],
            ),

    );
  }

  @override
  void dispose() {
    stop();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      stop();
    }
  }

  void speak(String text) async {
    print('*******************************played');
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  void stop() async {
    await flutterTts.stop();
  }
}