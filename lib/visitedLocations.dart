import 'dart:core';


class  Userlocations
{
  List<String> locations=[];
  void addLocation(String location)
  {
    locations.add(location);
  }
  List<String> getPreLocations()
  {
    return locations;
  }
}

