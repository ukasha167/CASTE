import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import '../controllers/weather_controller.dart';

class CitySearch extends StatefulWidget {
  final WeatherController controller;
  final VoidCallback onCitySelected;

  const CitySearch({
    required this.controller,
    required this.onCitySelected,
    super.key,
  });

  @override
  State<CitySearch> createState() => _CitySearchState();
}

class _CitySearchState extends State<CitySearch> {
  final TextEditingController _textController = TextEditingController();
  Timer? _debounce;
  List<dynamic> _results = [];
  bool _isLoading = false;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final results = await widget.controller.searchCities(query);
      if (mounted) {
        setState(() {
          _results = results;
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              controller: _textController,
              onChanged: _onSearchChanged,
              autofocus: true,
              style: GoogleFonts.montserrat(
                color: Colors.deepOrange[50],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              cursorColor: Colors.deepOrange[50],
              decoration: InputDecoration(
                hintText: "Search city...",
                hintStyle: GoogleFonts.montserrat(
                  color: Colors.deepOrange[50]!.withValues(alpha: 0.5),
                ),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: Colors.deepOrange[50]!.withValues(alpha: 0.7),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),

          const SizedBox(height: 20),

          if (_isLoading)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CupertinoActivityIndicator(
                  color: Colors.deepOrange[50],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: _results.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.white.withValues(alpha: 0.1),
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final city = _results[index];
                  final cityName = city['name'] ?? 'Unknown';
                  final country = city['country'] ?? '';
                  final admin1 = city['admin1'] ?? '';

                  final subtitle = [admin1, country]
                      .where((e) => e.toString().isNotEmpty)
                      .join(', ');

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      cityName,
                      style: GoogleFonts.montserrat(
                        color: Colors.deepOrange[50],
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                    subtitle: Text(
                      subtitle,
                      style: GoogleFonts.montserrat(
                        color: Colors.deepOrange[50]!.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w400,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                    onTap: () {
                      widget.controller.fetchWeatherForCity(
                        city['latitude'],
                        city['longitude'],
                        cityName,
                      );
                      widget.onCitySelected();
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
