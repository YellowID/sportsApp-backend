module V1
  class ApiPing < Grape::API
    get :ping do
      { ping: 'pong' }
    end
  end
end
