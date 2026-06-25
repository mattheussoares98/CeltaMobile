enum TextType {
  caption(10),
  bodySmall(12),
  bodyMedium(14),
  bodyLarge(16),
  titleSmall(18),
  titleMedium(20),
  titleLarge(22),
  headline(24),
  headlineLarge(32);

  const TextType(this.size);
  final double size;
}
