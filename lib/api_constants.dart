

class Api {
  static getBaseUrl() {
    return 'http://192.168.35.5:81/V1/Api/';
  }

  static getInventoryBaseUrl() {
    // final serverIp = UserSimplePreferences.getServerIp() ?? '';
    return 'http://192.168.35.5:81/V1/Inventory/';
  }

  static getEmployeeBaseUrl() {
    // final serverIp = UserSimplePreferences.getServerIp() ?? ''
    return 'http://192.168.35.5:81/V1/Employee/';
  }
}
