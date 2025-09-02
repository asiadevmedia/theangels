extension StringExtension on String {
  String toSentenceCase() {
    if (isEmpty) {
      return '';
    }

    // Capitalize the first letter of the text
    String result = substring(0, 1).toUpperCase() + substring(1);

    // Find periods followed by spaces and capitalize the next character
    result = result.replaceAllMapped(
      RegExp(r'\. +(\w)'),
      (match) => '. ${match.group(1)!.toUpperCase()}',
    );

    return result;
  }
}
