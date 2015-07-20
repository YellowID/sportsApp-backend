module APIHelpers
  def api(url, user = nil, version = 'v1')
    custome_url = "/api/#{version}/#{url}#{url.index('?') ? '' : '?'}&api_key=#{api_key.access_token}"
    user ? custome_url << "&user_token=#{user.token}" : custome_url
  end

  def api_key
    @api_key ||= ApiKey.generate!
  end

  def api_token_param
    { 'Api-Token' => api_key.access_token }
  end

  def json_response
    JSON.parse(response.body)
  end
end

