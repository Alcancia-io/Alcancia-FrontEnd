enum CurrencyAsset {
  aPolUSDC(actualAsset: "aPolUSDC", shownAsset: "USDC"),
  mcUSD(actualAsset: "mcUSD", shownAsset: "cUSD"),
  mxn(actualAsset: "MXN", shownAsset: "MXN");

  const CurrencyAsset({required this.actualAsset, required this.shownAsset});

  final String actualAsset;
  final String shownAsset;
}
