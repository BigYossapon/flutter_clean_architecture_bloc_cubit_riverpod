import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.dev.env', obfuscate: true)
abstract class EnvDev {
  @EnviedField(varName: "BASE_URL", obfuscate: true)
  static final String baseUrl = _EnvDev.baseUrl;
}

@Envied(path: '.sit.env', obfuscate: true)
abstract class EnvSit {
  @EnviedField(varName: "BASE_URL", obfuscate: true)
  static final String baseUrl = _EnvSit.baseUrl;
}

@Envied(path: '.uat.env', obfuscate: true)
abstract class EnvUat {
  @EnviedField(varName: "BASE_URL", obfuscate: true)
  static final String baseUrl = _EnvUat.baseUrl;
}

@Envied(path: '.prod.env', obfuscate: true)
abstract class EnvProd {
  @EnviedField(varName: "BASE_URL", obfuscate: true)
  static final String baseUrl = _EnvProd.baseUrl;
}
