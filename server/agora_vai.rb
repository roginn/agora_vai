require 'sinatra/base'
require 'rubygems'
require 'sinatra'
require 'fileutils'


class AgoraVai < Sinatra::Application
  get '/' do
    'PEIXE ESTEVE AQUI CARAJO!'
  end


 
# upload with:
# curl -v -F "data=@/path/to/filename"  http://localhost:4567/user/filename


#escreve arquivo em agora_vai/files/name/filename
post '/:name/:filename' do
  userdir = File.join("files", params[:name])
  FileUtils.mkdir_p(userdir)
  filename = File.join(userdir, params[:filename])
  datafile = params[:data]
#  "#{datafile[:tempfile].inspect}\n"
  File.open(filename, 'wb') do |file|
    file.write(datafile[:tempfile].read)
  end

  #tesseract com imagem



  #faz o naivebayes


  "wrote to #{filename}\n"
end




  # start the server if ruby file executed directly
  run! if app_file == $0
end
