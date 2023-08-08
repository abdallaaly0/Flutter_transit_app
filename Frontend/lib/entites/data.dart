// model class for handling a single post data.
class Data {
  String data;

  Data({
    required this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "data": data,
      };
}
