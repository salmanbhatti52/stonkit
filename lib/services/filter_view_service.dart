import '../resources/assets.dart';

Map<String, String> sectorNameMapping = {
  'Financial Services': 'Financials',
  'Consumer Cyclical': 'Consumer \n Discretionary',
  'Consumer Defensive': 'Consumer \n Staples',
  'Healthcare': 'Health Care',
  'Basic Materials': 'Materials',
  'Communication Services': 'Communication \n Services',
  // Others match directly
};

Map<String, String> sectorIcons = {
  'Technology': Assets.tech,
  'Financial Services': Assets.finance,
  'Consumer Cyclical': Assets.consumerDisc,
  'Consumer Defensive': Assets.consumerStaple,
  'Healthcare': Assets.healthCare,
  'Industrials': Assets.factory,
  'Utilities': Assets.electric,
  'Basic Materials': Assets.material,
  'Real Estate': Assets.realEstate,
  'Energy': Assets.energy,
  'Communication Services': Assets.chat,
  // Add all mappings
};
