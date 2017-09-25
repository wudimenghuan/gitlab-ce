class ExternalWikiService < Service
  include HTTParty

  prop_accessor :external_wiki_url

  validates :external_wiki_url, presence: true, url: true, if: :activated?

  def title
    '外部维基'
  end

  def description
    '将内部维基的连接替换成外部维基。'
  end

  def self.to_param
    'external_wiki'
  end

  def fields
    [
      { type: 'text', name: 'external_wiki_url', placeholder: '外部维基 URL 地址', required: true }
    ]
  end

  def execute(_data)
    @response = HTTParty.get(properties['external_wiki_url'], verify: true) rescue nil
    if @response != 200
      nil
    end
  end

  def self.supported_events
    %w()
  end
end
