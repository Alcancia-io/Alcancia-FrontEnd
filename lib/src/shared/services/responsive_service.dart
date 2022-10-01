class ResponsiveService {
  final double _iPhone13Height = 844;
  final double _iPhone13Width = 390;

  double getHeightPixels(double targetPixels, double currentScreenHeight) {
    var pixels = currentScreenHeight * (targetPixels / _iPhone13Height);
    return pixels;
  }

  double getWidthPixels(double targetPixels, double currentScrrenWidth) {
    var pixels = currentScrrenWidth * (targetPixels / _iPhone13Width);
    return pixels;
  }
}
