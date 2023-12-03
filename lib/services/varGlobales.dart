class VariablesGlobales {
  String urlHttp;

  VariablesGlobales({this.urlHttp = "http://localhost:8080"});

  void setUrlHttp(String url_http) {
    urlHttp = url_http;
  }

  String getUrlHttp() {
    return urlHttp;
  }
}
