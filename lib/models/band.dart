class Band{
  String id;
  String name;
  int votes;
  Band({required this.id, required this.name, this.votes=0});

  factory Band.fromJson(Map<String, dynamic> json){
    return Band(
      id: json['id'],
      name: json['name'],
      votes: json['votes']
    );
  }
}