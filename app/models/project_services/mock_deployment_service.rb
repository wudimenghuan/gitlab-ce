class MockDeploymentService < DeploymentService
  def title
    'Mock 部署'
  end

  def description
    'Mock 部署服务'
  end

  def self.to_param
    'mock_deployment'
  end

  # No terminals support
  def terminals(environment)
    []
  end
end
