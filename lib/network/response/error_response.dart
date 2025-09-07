class ErrorResponse{
  final String static;
  final String code;
  final String message;

  ErrorResponse(
      this.static,
      this.code,
      this.message
      );
  factory ErrorResponse.fromMap(Map<String,dynamic>map){
    return ErrorResponse(
        map['static']??"",
        map['code']??"",
        map['message']??"");
  }
  Map<String,dynamic> toMap(){
    return{
      'static':static,
      'code':code,
      'message':message
    };
  }

}