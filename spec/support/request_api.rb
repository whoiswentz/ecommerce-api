module RequestAPI
  def json_body(symbolize_keys: false)
    begin
      json = JSON.parse(response.body)
      symbolize_keys ? json.deep_symbolize_keys : json
    rescue
      return {}
    end
  end

  def auth_header(user = nil, merge_with: {})
    user ||= create(:user)
    auth = user.create_new_auth_token
    header = auth.merge({
                          'Content-Type' => 'application/json',
                          'Accept' => 'application/json'
                        })
    header.merge(merge_with)
  end
end

RSpec.configure do |config|
  config.include RequestAPI, type: :request
end