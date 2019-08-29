

import 'dart:io';

class PathMatcher{
  String path;
  RegExp pattern;

  PathMatcher({this.path,String pattern}){
    this.pattern= RegExp(pattern);
  }

  bool matches(String pathName){
    return path == pathName || pattern.hasMatch(pathName);
  }
}

typedef RequestHandler = Function(HttpRequest,HttpResponse,{Function(dynamic) next});



enum HttpMethod{
  GET,POST,PUT,PATCH,DELETE,OPTIONS,CONNECT
}

abstract class RouterProps{
  void get(dynamic Path,RequestHandler handler);
  void post(dynamic Path,RequestHandler handler);
  void put(dynamic Path,RequestHandler handler);
  void patch(dynamic Path,RequestHandler handler);
  void delete(dynamic Path,RequestHandler handler);
  void options(dynamic Path,RequestHandler handler);
  void connect(dynamic Path,RequestHandler handler);
}

