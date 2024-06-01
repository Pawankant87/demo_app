class Customer {
  final int? id;
  final String name;
  final String mobile;
  final String email;
  final String address;
  final String imageUrl;

  Customer({
    this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.address,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'email': email,
      'address': address,
      'imageUrl': imageUrl,
    };
  }

  static Customer fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      mobile: map['mobile'],
      email: map['email'],
      address: map['address'],
      imageUrl: map['imageUrl'],
    );
  }
}
