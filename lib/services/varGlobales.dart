class VariablesGlobales {
  String urlHttp;

  //VariablesGlobales({this.urlHttp = "http://54.85.247.196:8080"});
  VariablesGlobales({this.urlHttp = "http://192.168.1.12:8080/estudiantes"});

  void setUrlHttp(String url_http) {
    urlHttp = url_http;
  }

  String getUrlHttp() {
    return urlHttp;
  }
}
