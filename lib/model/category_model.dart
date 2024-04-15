class Categories{
  final String id;
  final String name;
  final String image;

  Categories({
    required this.id,
    required this.name,
    required this.image
});

  factory Categories.fromJson(Map<String,dynamic> json){
    return Categories(
        id: (json['id']).toString() ?? '',
        name: json['name'] ?? '',
        image: json['image'] ?? ''
    );
  }

}