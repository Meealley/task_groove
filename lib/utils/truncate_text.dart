String truncateWords(String text, int wordLimit) {
  final words = text.split(' ');
  if (words.length <= wordLimit) {
    return text; // Return the full text if it has 30 or fewer words
  }
  final truncatedText = words.take(wordLimit).join(' ');
  return '$truncatedText...'; // Add ellipsis after truncating
}

String truncateText(String text, int charLimit) {
  if (text.length <= charLimit) {
    return text; // Return the full text if it's within the character limit
  }
  final truncatedText = text.substring(0, charLimit);
  return '$truncatedText...';
}
