class Endpoints {
  // static const String $baseUrl = 'https://cachyos.tailfb4b08.ts.net:10000';
  // static const String $baseUrl = 'http://10.0.2.2:8000';
  // static const String $baseUrl = 'https://philanthropically-farsighted-malik.ngrok-free.dev';
  static const String $baseUrl = "https://farmbros.finalyze.app";
  static const String $register = "${$baseUrl}/users/create";
  static const String $login = "${$baseUrl}/users/login";

  // farm routes
  static const String $saveFarm = "${$baseUrl}/farms/create";
  static const String $getMyFarms = "${$baseUrl}/farms/get_user_farms";
  static const String $getFarm = "${$baseUrl}/farms/get_farm";

  // plot routes
  static const String $savePlot = "${$baseUrl}/plots/create";
  static const String $getPlot = "${$baseUrl}/plots/get_plot";
  static const String $getFarmPlots = "${$baseUrl}/plots/get_plots_by_farm";

  // logger routes
  static const String $getAllCrops = "${$baseUrl}/crops/get_all";

  // planted crops routes
  static const String $savePlantedCrop = "${$baseUrl}/planted_crops/create";
  static const String $getAllPlantedCrops = "${$baseUrl}/planted_crops/get_all";
}
