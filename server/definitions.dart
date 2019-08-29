

import 'dart:io';

typedef MiddleWare = Function(HttpRequest,HttpResponse,{Function(dynamic)next});