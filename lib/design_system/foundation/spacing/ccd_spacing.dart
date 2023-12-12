enum CcdSpacing {
  s8(value: 8.0),
  s16(value: 16.0),
  s24(value: 24.0),
  s32(value: 32.0);

  final double value;

  const CcdSpacing({required this.value});
}
