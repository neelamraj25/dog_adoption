import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app/bloc/petBloc/pet_bloc.dart';
import 'package:pet_adoption_app/bloc/petBloc/pet_event.dart';
import 'package:pet_adoption_app/bloc/petBloc/pet_state.dart';
import 'package:pet_adoption_app/screen/history_page.dart';
import 'package:pet_adoption_app/screen/pet_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Pet Adoption',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage()),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchField(context),
            _buildBreedFilterDropdown(context),
            _buildPetList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search pets by name...',
          hintStyle: TextStyle(color: Colors.grey.shade600),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          prefixIcon: Icon(Icons.search, color: Colors.teal),
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
        onChanged: (value) {
          context.read<PetBloc>().add(SearchPets(value));
        },
      ),
    );
  }

  Widget _buildBreedFilterDropdown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButton<String>(
        isExpanded: true,
        hint: Text("Filter by breed", style: TextStyle(color: Colors.teal)),
        items: [
          "Labrador Retriever",
          "German Shepherd",
          "Siberian Husky",
          "Golden Retriever",
          "Beagle",
          "Border Collie",
          "Rottweiler",
          "Cavalier King Charles Spaniel",
          "Australian Shepherd",
          "Boxer"
        ]
            .map((breed) => DropdownMenuItem(
                  value: breed,
                  child: Text(breed, style: TextStyle(color: Colors.black)),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            context.read<PetBloc>().add(FilterPets(value));
          }
        },
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(8),
        elevation: 3,
      ),
    );
  }

  Widget _buildPetList(BuildContext context) {
    return Expanded(
      child: BlocBuilder<PetBloc, PetState>(
        builder: (context, state) {
          if (state is PetLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PetLoaded) {
            if (state.pets.isEmpty) {
              return Center(
                child: Text(
                  'No data available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              itemCount: state.pets.length,
              itemBuilder: (context, index) {
                final pet = state.pets[index];
                return _buildPetCard(context, pet);
              },
            );
          } else if (state is PetError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('No pets available'));
        },
      ),
    );
  }

  Widget _buildPetCard(BuildContext context, Map<String, String> pet) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.teal.shade100, width: 1),
      ),
      elevation: 4,
      child: ListTile(
        leading: Hero(
          tag: 'pet-image-${pet['name']}',
          child: ClipOval(
            child: Image.asset(
              pet['image']!,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          pet['name']!,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        subtitle: Text(
          '${pet['breed']} - ${pet['age']} years old',
          style: TextStyle(color: Colors.grey.shade700),
        ),
        onTap: () async {
          final prefs = await SharedPreferences.getInstance();
          final petName = pet['name']!;
          await prefs.setString('${petName}-date', DateTime.now().toIso8601String());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PetDetailsPage(pet: pet),
            ),
          );
        },
      ),
    );
  }
}
