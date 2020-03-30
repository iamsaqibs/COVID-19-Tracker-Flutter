class CountryData {
  String id;
  String name;
  String long;
  String lat;
  String cases;
  String todayCases;
  String deaths;
  String todayDeaths;
  String recovered;
  String active;
  String critical;
  String flag;
  String casesPerMillion;
  String deathsPerMillion;

  CountryData(this.id, this.name, this.long, this.lat, this.cases, this.todayCases,
      this.deaths, this.todayDeaths, this.recovered, this.active, this.critical,
      this.flag, this.casesPerMillion, this.deathsPerMillion);
}
