enum TextType {
  caption(10),
  bodySmall(12),
  bodyMedium(14),
  bodyLarge(16),
  titleSmall(14),
  titleMedium(16),
  titleLarge(18),
  headline(24),
  headlineLarge(32);

  const TextType(this.size);
  final double size;
}
