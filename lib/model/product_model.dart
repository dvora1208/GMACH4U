class ProductModel {
  final String name;
  final String image;
  final String description;
  final int count;
  final String gid;
  final int broken;
  final int maxBorrowDays;

  ProductModel({
    this.maxBorrowDays,
    this.description,
    this.count,
    this.name,
    this.image,
    this.gid,
    this.broken,
  });

  static ProductModel fromMap(Map map) {
    return ProductModel(
        name: map['name'] ?? '',
        image: map['image'] ?? '',
        description: map['description'] ?? '',
        count: map['count'] ?? 0,
        maxBorrowDays: map['max_borrow_days'] ?? 10,
        gid: map['gid'] ?? '',
        broken: map['broken'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
      'name': name,
      'image': image,
      'description': description,
      'count': count,
      'maxBorrowDays':maxBorrowDays,
      'gid': gid,
      'broken': broken,
  };
}
