module APIHelpers
  def api(url, version = 'v1')
    "/api/#{version}/#{url}#{url.index('?') ? '' : '?'}&api_token=#{api_key.access_token}"
  end

  def api_key
    @api_key ||= ApiKey.generate!
  end

  def api_token_param
    { 'Api-Token' => api_key.access_token }
  end

  def json_response
    JSON.parse(response.body).with_indifferent_access
  end
end

