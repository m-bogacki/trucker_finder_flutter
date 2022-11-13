String normalizeText(String text) {
  text = text.trim().replaceAllMapped(RegExp(r'[^A-Za-z0-9]'), (m) {
    return '';
  });
  return text;
}

bool containSpecialCharacters(String text, bool numbers) {
  String regexedValue =
      text.replaceAll(RegExp('[^A-Za-z${numbers ? '0-9' : ''}]'), '');
  if (regexedValue.length != text.length) {
    return true;
  }
  return false;
}
