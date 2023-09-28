class Customer {
  final String name;
  final String number;
  final String companyName;
  final Address address;

  const Customer ({
     this.name = "Customer Name",
     this.number = "Customer Number",
     this.companyName = "Customer's Company Name",
    required this.address,
  });
}

class Address {
  final String address;
  final String city;

  const Address ({
    this.address = "Customer's Address",
    this.city = "Customer's City",
  });
}
