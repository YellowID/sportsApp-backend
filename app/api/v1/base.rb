module V1
  class Base < Grape::API
    version 'v1', using: :path
    helpers V1::APIHelpers

    prefix 'api'

    mount ApiPing
    mount ApiUsers
    mount ApiSportType
    mount ApiGames
    mount ApiInvitation
  end
end
