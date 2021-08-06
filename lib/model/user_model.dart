class UserModel{
  final List<String> borrowedProducts;
  final String name;
  final String email;
  final String phone;

  UserModel({this.name, this.phone, this.email, this.borrowedProducts});

  static UserModel fromMap(Map<String, dynamic> map) => UserModel(
    name: map['name'] ?? '?',
    email: map['email'] ?? '?',
    phone: map['phone'] ?? '?',
    borrowedProducts: (map['borrowedProducts'] ?? []).cast<String>(),
  );
}