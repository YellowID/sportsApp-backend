require 'grape-swagger'

class API < Grape::API
  before do
    I18n.locale = :en
    header['Access-Control-Allow-Origin'] = '*'
    header['Access-Control-Request-Method'] = '*'
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    error_response({ message: e.message, status: 404 })
  end

  content_type :xml, 'application/xml'
  content_type :json, 'application/json'

  format :json
  default_format :json

  mount V1::Base

  add_swagger_documentation(
    {
      hide_documentation_path: true,
      api_version: 'v1',
      base_path: lambda do |request|
        Rails.env.development? ? request.base_url : "#{request.scheme}://#{request.host}"
      end
    }
  )
end

