require 'sinatra/base'
require 'rubygems'
require 'sinatra'
require 'haml'


class AgoraVai < Sinatra::Application
  get '/' do
    'PEIXE ESTEVE AQUI CARAJO!'
  end


 
# Handle GET-request (Show the upload form)
get "/upload" do
  haml :upload
end      
    
# Handle POST-request (Receive and save the uploaded file)
post "/upload" do 
  File.open('uploads/' + params['myfile'][:filename], "w") do |f|
    f.write(params['myfile'][:tempfile].read)
  end
  return "The file was successfully uploaded!"
end




  # start the server if ruby file executed directly
  run! if app_file == $0
end
