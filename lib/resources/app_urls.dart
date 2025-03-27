class AppUrls {
  static const apiBaseUrl =
      'https://slategrey-cormorant-857845.hostingersite.com/api/';
  static const imgBaseUrl =
      'https://slategrey-cormorant-857845.hostingersite.com/public/';
  static const apiBaseUrlOfFMP = 'https://financialmodelingprep.com/stable/';
  static const apiKeyOfFMP = 'gq6cyoIoSsnVKypgjH1XfJBFot5jaxU6';

  static const signupWithApp = '${apiBaseUrl}user_signup';
  static const loginWithApp = '${apiBaseUrl}users_login';
  static const loginAsGuest = '${apiBaseUrl}guest_user';
  static const resetPasswordOtp = '${apiBaseUrl}reset_password';
  static const setNewPassword = '${apiBaseUrl}update_password';
  static const changePassword = '${apiBaseUrl}change_password';
  static const deleteAccount = '${apiBaseUrl}delete_account';
  static const likeTicker = '${apiBaseUrl}like_ticker';
  static const getLikedTickers = '${apiBaseUrl}get_liked_ticker';

  // home Urls
  static const stockScreener =
      '${apiBaseUrlOfFMP}company-screener?apikey=$apiKeyOfFMP';

  static const companyProfile = '${apiBaseUrlOfFMP}profile?apikey=$apiKeyOfFMP';
  static const companyStockPrice =
      '${apiBaseUrlOfFMP}quote?apikey=$apiKeyOfFMP';
  static const historicalStockPrice =
      '${apiBaseUrlOfFMP}historical-price-eod/full?apikey=$apiKeyOfFMP';
  static const historicalSectorPerformance =
      '${apiBaseUrlOfFMP}historical-sector-performance?apikey=$apiKeyOfFMP';
  static const companyDividends =
      '${apiBaseUrlOfFMP}dividends?apikey=$apiKeyOfFMP';
}
