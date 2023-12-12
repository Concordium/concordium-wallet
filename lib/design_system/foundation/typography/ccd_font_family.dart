enum CcdFontFamily {
  bold(name: "${_prefix}Bold"),
  semibold(name: "${_prefix}Semibold"),
  medium(name: "${_prefix}Medium"),
  regular(name: "${_prefix}Regular"),
  light(name: "${_prefix}Regular");

  final String name;

  const CcdFontFamily({required this.name});

  static const String _prefix = "IBM Plex Sans - ";
}
