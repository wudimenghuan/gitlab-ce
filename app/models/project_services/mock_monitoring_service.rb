class MockMonitoringService < MonitoringService
  def title
    'Mock 监控'
  end

  def description
    'Mock 监控服务'
  end

  def self.to_param
    'mock_monitoring'
  end

  def metrics(environment)
    JSON.parse(File.read(Rails.root + 'spec/fixtures/metrics.json'))
  end

  def can_test?
    false
  end
end
