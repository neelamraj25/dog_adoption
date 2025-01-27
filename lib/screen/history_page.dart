import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, String>> adoptedPets = [];

  @override
  void initState() {
    super.initState();
    _loadAdoptedPets();
  }

  Future<void> _loadAdoptedPets() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> adoptedPetKeys = prefs.getKeys().toList();

    List<Map<String, String>> pets = [];
    for (var key in adoptedPetKeys) {
      if (key.endsWith('-date')) {
        String? adoptionDate = prefs.getString(key);
        if (adoptionDate != null) {
          String petName = key.replaceFirst('-date', '');
          pets.add({
            'name': petName,
            'adoptedDate': adoptionDate,
          });
        }
      }
    }

    pets.sort((a, b) => DateTime.parse(a['adoptedDate']!)
        .compareTo(DateTime.parse(b['adoptedDate']!)));

    setState(() {
      adoptedPets = pets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adopted Pets History', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        elevation: 4.0,
      ),
      body: ListView.builder(
        itemCount: adoptedPets.length,
        itemBuilder: (context, index) {
          final pet = adoptedPets[index];

          DateTime adoptionDate = DateTime.parse(pet['adoptedDate']!);
          String formattedDate = DateFormat('MMM dd, yyyy h:mm a').format(adoptionDate); // More readable format

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.shade100,
                    child: Icon(Icons.pets, color: Colors.white),
                  ),
                  title: Text(
                    pet['name']!,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.teal),
                  ),
                  subtitle: Text(
                    'Adopted on: $formattedDate',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
