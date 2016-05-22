require 'sinatra/base'

class AgoraVai < Sinatra::Application
  get '/' do
    'PEIXE ESTEVE AQUI CARAJO!'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
