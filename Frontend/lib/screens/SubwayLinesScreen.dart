import 'package:flutter/material.dart';
import 'package:flutter_transit_app/maps.dart';

Map<String, List<String>> subwayLines = {
  '1': [
    'Van Cortlandt Park-242 St',
    '238 St',
    '231 St',
    'Marble Hill-225 St',
    '215 St',
    '207 St',
    'Dyckman St',
    '191 St',
    '181 St',
    '168 St',
    '157 St',
    '145 St',
    '137 St City College',
    '125 St',
    '116 St Columbia University',
    'Cathedral Pkwy (110 St)',
    '103 St',
    '96 St',
    '86 St',
    '79 St',
    '72 St',
    '66 St Lincoln Center',
    '59 St Columbus Circle',
    '50 St',
    'Times Sq-42 St',
    '34 St Penn Station',
    '28 St',
    '23 St',
    '18 St',
    '14 St',
    'Christopher St Sheridan Sq',
    'Houston St',
    'Canal St',
    'Franklin St',
    'Chambers St',
    'WTC Cortlandt',
    'Rector St',
    'South Ferry'
  ],
  '2': [
    'Wakefield-241 St',
    'Nereid Ave',
    '233 St',
    '225 St',
    '219 St',
    'Gun Hill Rd',
    'Burke Av',
    'Allerton Av',
    'Pelham Plwy',
    'Bronx Park East',
    'E 180 St',
    'West Farms Sq E Tremont Av',
    '174 St',
    'Freeman St',
    'Simpson St',
    'Intervale Av',
    'Prospect Av',
    'Jackson Av',
    '3 Av- 149 St',
    '149 St- Grand Concourse',
    '135 St',
    '125 St',
    '116 St',
    'Central Park North (110 St)',
    '96 St',
    '72 St',
    'Times Sq- 42 St',
    '34 St- Penn Station',
    '14 St',
    'Chambers St',
    'Park Place',
    'Fulton St',
    'Wall St',
    'Clark St',
    'Borough Hall',
    'Hoyt St',
    'Nevins St',
    'Atlantic Av- Barclays Ctr',
    'Bergen St',
    'Grand Army Plaza',
    'Eastern Pkwy Brooklyn Museum',
    'Franklin Av-Medgar Evers College',
    'President St-Medgar Evers College',
    'Sterling St',
    'Winthrop St',
    'Church Av',
    'Beverly Rd',
    'Newkirk Av',
    'Flatbush Av Brooklyn College'
  ],
  '3': ['Harlem-148 St', '145 St', '135 St', '...'],
  '4': ['Woodlawn', 'Mosholu Pkwy', 'Bedford Park Blvd-Lehman College', '...'],
  '5': ['Eastchester-Dyre Ave', 'Baychester Ave', 'Gun Hill Rd', '...'],
  '6': ['Pelham Bay Park', 'Buhre Ave', 'Middletown Rd', '...'],
  '7': ['Flushing-Main St', 'Mets-Willets Point', '111 St', '...'],
  'A': [
    'Inwood-207 St',
    'Dyckman St',
    '190 St',
    '181 St',
    '175 St',
    '168 St',
    '145 St',
    '125 St',
    '59 St Columbus Circle',
    '42 St/Port Authority Bus Terminal',
    '34 St Penn Station',
    '14 St',
    'W 4 St Wash Sq',
    'Canal St',
    'Chambers St',
    'Fulton St',
    'High St',
    'Jay St- MetroTech',
    'Hoyt Schermerhorn',
    'Nostrand Av',
    'Utica Av',
    'Broadway Junction',
    'Euclid Av',
    'Grant Av',
    '80 St',
    '88 St',
    'Rockaway Blvd'
  ],
  'C': ['168 St', '163 St-Amsterdam Ave', '155 St', '...'],
  'E': [
    'Jamaica Center-Parsons/Archer',
    'Sutphin Blvd-Archer Av-JFK Airport',
    'Jamaica-Van Wyck',
    '...'
  ],
  'B': ['Bedford Park Blvd', 'Kingsbridge Rd', 'Fordham Rd', '...'],
  'D': ['Norwood-205 St', 'Bedford Park Blvd', 'Kingsbridge Rd', '...'],
  'F': ['Jamaica-179 St', '169 St', 'Parsons Blvd', '...'],
  'M': ['Forest Hills-71 Av', '67 Av', '63 Dr-Rego Park', '...'],
  'G': ['Court Sq', '21 St', 'Greenpoint Ave', '...'],
  'J': [
    'Jamaica Center-Parsons/Archer',
    'Sutphin Blvd-Archer Av',
    '121 St',
    '...'
  ],
  'Z': [
    'Jamaica Center-Parsons/Archer',
    'Sutphin Blvd-Archer Av',
    '121 St',
    '...'
  ],
  'L': ['Canarsie-Rockaway Pkwy', 'E 105 St', 'New Lots Av', '...'],
  'S': ['Grand Central-42 St', 'Times Sq-42 St', '...'],
  'N': ['Astoria-Ditmars Blvd', 'Astoria Blvd', '30 Av', '...'],
  'Q': ['96 St', '86 St', '72 St', '...'],
  'R': ['Forest Hills-71 Av', '67 Av', '63 Dr-Rego Park', '...'],
  'W': ['Astoria-Ditmars Blvd', 'Astoria Blvd', '30 Av', '...'],
};

Color getBackgroundColor(String line) {
  switch (line) {
    case 'A':
    case 'C':
    case 'E':
      return Colors.blue[900]!;
    case '1':
    case '2':
    case '3':
      return Colors.red;
    case 'G':
      return Color.fromARGB(255, 97, 234, 104);
    case 'B':
    case 'D':
    case 'F':
    case 'M':
      return Colors.orange;
    case 'J':
    case 'Z':
      return Colors.brown;
    case 'L':
    case 'S':
      return Colors.grey;
    case '4':
    case '5':
    case '6':
      return Colors.green[900]!;
    case '7':
      return Colors.purple;
    case 'N':
    case 'Q':
    case 'R':
    case 'W':
      return Color.fromARGB(255, 255, 230, 0);
    default:
      return Colors.blue;
  }
}

Color getTextColor(String line) {
  if (['N', 'Q', 'R', 'W'].contains(line)) {
    return Colors.black;
  }
  return Colors.white;
}

class SubwayLinesScreen extends StatelessWidget {
  const SubwayLinesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MTA Subway Lines'),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.black12,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapSample()),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.star,
                  color: Theme.of(context).accentColor,
                ),
                Text('Map'),
              ],
            ),
          ),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: subwayLines.keys.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Choose the number of items per row
          crossAxisSpacing: 5.0, // Spacing between items horizontally
          mainAxisSpacing: 5.0, // Spacing between items vertically
          childAspectRatio: 1.0, // Aspect ratio of each grid item
        ),
        itemBuilder: (context, index) {
          final line = subwayLines.keys.elementAt(index);
          return Container(
            decoration: BoxDecoration(
              color: getBackgroundColor(line),
              shape: BoxShape.circle,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubwayStopsScreen(line: line),
                    ),
                  );
                },
                child: Center(
                  child: Text(line,
                      style: TextStyle(
                          fontSize: 50,
                          color: getTextColor(line),
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SubwayStopsScreen extends StatelessWidget {
  final String line;

  const SubwayStopsScreen({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stations on the $line line')),
      body: ListView.builder(
        itemCount: subwayLines[line]?.length ?? 0,
        itemBuilder: (context, index) {
          final stop = subwayLines[line]?[index];
          return ListTile(
            title: Row(
              children: [
                Container(
                  width: 12.0, // Adjust width and height
                  height: 12.0,
                  margin: EdgeInsets.only(right: 8.0), // Add spacing
                  decoration: BoxDecoration(
                    color: getBackgroundColor(line),
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    stop ?? 'Unknown stop',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
