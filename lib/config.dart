class Environments {
  static const String PRODUCTION = 'prod';
  static const String QAS = 'QAS';
  static const String DEV = 'dev';
  static const String LOCAL = 'local';
}

class ConfigEnvironments {
  static const String _currentEnvironments = Environments.LOCAL;
  static final List<Map<String, String>> _availableEnvironments = [
    {
      'env': Environments.LOCAL,
      'url': 'https://api.todoist.com/rest/v2',
      'urlSync':'https://api.todoist.com/sync/v9'
    },
    {
      'env': Environments.DEV,
      'url': 'https://api.todoist.com/rest/v2',
      'urlSync':'https://api.todoist.com/sync/v9'
    },
    {
      'env': Environments.QAS,
      'url': 'https://api.todoist.com/rest/v2',
      'urlSync':'https://api.todoist.com/sync/v9'
    },
    {
      'env': Environments.PRODUCTION,
      'url': 'https://api.todoist.com/rest/v2',
      'urlSync':'https://api.todoist.com/sync/v9'
    },
  ];

  static Map<String, String> getEnvironments() {
    return _availableEnvironments.firstWhere(
      (d) => d['env'] == _currentEnvironments,
    );
  }
}
