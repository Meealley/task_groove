String truncateText(String text, int wordLimit) {
  final words = text.split(' ');
  if (words.length <= wordLimit) {
    return text; // Return the full text if it has 30 or fewer words
  }
  final truncatedText = words.take(wordLimit).join(' ');
  return '$truncatedText...'; // Add ellipsis after truncating
}
