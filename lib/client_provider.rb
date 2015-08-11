require 'net/http'

VK_URL = 'https://api.vk.com/method/users.get?fields=photo_200,email&access_token='.freeze

class ClientProvider
  def initialize(provider, oauth_token)
    @oauth_token = oauth_token
    @provider = provider
  end

  def get_info
    begin
      case @provider
      when 'facebook'
        client = Koala::Facebook::API.new(@oauth_token)
        response = client.get_object("me?fields=id,email,picture,name")

        {
          id: response['id'],
          name: response['name'],
          email: response['email'],
          avatar: response['picture']['data']['url']
        }
      when 'vk'
        url = "#{VK_URL}#{@oauth_token}"
        url = URI.parse(url)
        req = Net::HTTP::Get.new(url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        res = http.request(req)

        json_res = JSON.parse(res.body)

        return nil if json_res['error'].present?

        response = json_res['response'].first
        {
          id: response['uid'],
          name: "#{response['first_name']} #{response['last_name']}",
          email: response['email'],
          avatar: response['photo_200']
        }
      end
    rescue
      nil
    end

  end
end
