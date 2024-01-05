import 'package:flutter/material.dart';

import 'dto.dart';

class CitiesView extends StatelessWidget {
  final List<CityDto> _cities;

  const CitiesView(this._cities, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _cities.length,
      itemBuilder: (context, index) {
        final city = _cities[index];

        return ListTile(
          title: Text(city.name),
          trailing: Text('${city.population}'),
        );
      },
    );
  }
}
