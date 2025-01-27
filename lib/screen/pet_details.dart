import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:confetti/confetti.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class PetDetailsPage extends StatefulWidget {
  final Map<String, String> pet;

  const PetDetailsPage({super.key, required this.pet});

  @override
  _PetDetailsPageState createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  late ConfettiController _confettiController;
  bool isAdopted = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    _checkAdoptionStatus();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _checkAdoptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isAdopted = prefs.getBool(widget.pet['name']!) ?? false;
    });
  }

  Future<void> _adoptPet() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(widget.pet['name']!, true);
    setState(() {
      isAdopted = true;
    });
    _showAdoptedPopup();
  }

  void _showAdoptedPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.teal.shade100,
        title: Text(
          'You\'ve Adopted ${widget.pet['name']}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Congratulations on adopting ${widget.pet['name']}!',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _confettiController.stop();
            },
            child: Text(
              'OK',
              style: TextStyle(color: Colors.teal),
            ),
          ),
        ],
      ),
    );

    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 12,
        title: Text(
          widget.pet['name']!,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {
              final String petDetails = 
                'Check out this pet: ${widget.pet['name']} - ${widget.pet['breed']} (${widget.pet['age']} years old), \$${widget.pet['price']}';
              Share.share(petDetails);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildPetImage(),
              SizedBox(height: 20),
              _buildPetDetails(),
              SizedBox(height: 30),
              _buildAdoptButton(),
              SizedBox(height: 30),
              _buildConfetti(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetImage() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoViewGallery.builder(
              itemCount: 1,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: AssetImage(widget.pet['image']!),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered,
                );
              },
              scrollPhysics: BouncingScrollPhysics(),
              backgroundDecoration: BoxDecoration(color: Colors.black),
              pageController: PageController(),
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          widget.pet['image']!,
          height: 300,
          width: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPetDetails() {
    return Column(
      children: [
        Text(
          widget.pet['name']!,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        SizedBox(height: 10),
        Text(
          'Breed: ${widget.pet['breed']}',
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
        Text(
          'Age: ${widget.pet['age']} years old',
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
        SizedBox(height: 15),
        Text(
          'Price: \$${widget.pet['price']}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
        ),
      ],
    );
  }

  Widget _buildAdoptButton() {
    return isAdopted
        ? Column(
            children: [
              Text(
                'This pet has already been adopted.',
                style: TextStyle(color: Colors.grey[500], fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 30, vertical: 12)),
                ),
                child: Text('Already Adopted'),
              ),
            ],
          )
        : ElevatedButton(
            onPressed: _adoptPet,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            child: Text('Adopt Me', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          );
  }

  Widget _buildConfetti() {
    return ConfettiWidget(
      confettiController: _confettiController,
      blastDirectionality: BlastDirectionality.explosive,
      shouldLoop: false,
      gravity: 0.1,
    );
  }
}
