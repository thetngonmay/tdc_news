class EndPoint{
   static String BaseUrl = "https://newsapi.org/v2";

   static String everything ( String searchkey) => '$BaseUrl/everything?q=$searchkey';

   static String topHeadLine (String country) => '$BaseUrl/top-headlines?country=$country';
}