class CampfireService < Service
  include HTTParty

  prop_accessor :token, :subdomain, :room
  validates :token, presence: true, if: :activated?

  def title
    'Campfire'
  end

  def description
    '基于Web页面的简易实时群聊工具'
  end

  def self.to_param
    'campfire'
  end

  def fields
    [
      { type: 'text', name: 'token',     placeholder: '', required: true },
      { type: 'text', name: 'subdomain', placeholder: '' },
      { type: 'text', name: 'room',      placeholder: '' }
    ]
  end

  def self.supported_events
    %w(push)
  end

  def execute(data)
    return unless supported_events.include?(data[:object_kind])

    self.class.base_uri base_uri
    message = build_message(data)
    speak(self.room, message, auth)
  end

  private

  def base_uri
    @base_uri ||= "https://#{subdomain}.campfirenow.com"
  end

  def auth
    # use a dummy password, as explained in the Campfire API doc:
    # https://github.com/basecamp/campfire-api#authentication
    @auth ||= {
      basic_auth: {
        username: token,
        password: 'X'
      }
    }
  end

  # Post a message into a room, returns the message Hash in case of success.
  # Returns nil otherwise.
  # https://github.com/basecamp/campfire-api/blob/master/sections/messages.md#create-message
  def speak(room_name, message, auth)
    room = rooms(auth).find { |r| r["name"] == room_name }
    return nil unless room

    path = "/room/#{room["id"]}/speak.json"
    body = {
      body: {
        message: {
          type: 'TextMessage',
          body: message
        }
      }
    }
    res = self.class.post(path, auth.merge(body))
    res.code == 201 ? res : nil
  end

  # Returns a list of rooms, or [].
  # https://github.com/basecamp/campfire-api/blob/master/sections/rooms.md#get-rooms
  def rooms(auth)
    res = self.class.get("/rooms.json", auth)
    res.code == 200 ? res["rooms"] : []
  end

  def build_message(push)
    ref = Gitlab::Git.ref_name(push[:ref])
    before = push[:before]
    after = push[:after]

    message = ""
    message << "[#{project.name_with_namespace}] "
    message << "#{push[:user_name]} "

    if Gitlab::Git.blank_ref?(before)
      message << "推送了新的分支 #{ref} \n"
    elsif Gitlab::Git.blank_ref?(after)
      message << "删除了分支 #{ref} \n"
    else
      message << "推送了 #{push[:total_commits_count]} 个提交到 #{ref}。"
      message << "#{project.web_url}/compare/#{before}...#{after}"
    end

    message
  end
end
