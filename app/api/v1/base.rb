module V1
  class Base < Grape::API
    version 'v1', using: :path

    prefix 'api'

    mount ApiPing
  end
end
