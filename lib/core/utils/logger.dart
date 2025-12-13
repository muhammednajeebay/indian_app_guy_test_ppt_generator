void redPrint(String message) {
  print('\x1B[31m$message\x1B[0m');
}

void greenPrint(String message) {
  print('\x1B[32m$message\x1B[0m');
}

void yellowPrint(String message) {
  print('\x1B[33m$message\x1B[0m');
}

void bluePrint(String message) {
  print('\x1B[34m$message\x1B[0m');
}
