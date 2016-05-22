require 'sinatra/base'
require 'rubygems'
require 'sinatra'
require 'fileutils'

class AgoraVai < Sinatra::Application
  AGORA_VAI_HOME = '/home/ubuntu/agora_vai'

  get '/' do
    'PEIXE ESTEVE AQUI CARAJO!'
  end

  # upload with:
  # curl -v -F "data=@/path/to/filename"  http://localhost:4567/uploads/filename
  #escreve arquivo em agora_vai/uploads/filename
  post '/uploads/:filename' do
    userdir = File.join(AGORA_VAI_HOME, "uploads")
    FileUtils.mkdir_p(userdir) unless Dir.exists?(userdir)
    filename = File.join(userdir,params[:filename])
    datafile = params[:data]
  #  "#{datafile[:tempfile].inspect}\n"
    File.open(filename, 'wb') do |file|
      file.write(datafile[:tempfile].read)
    end

    # mandando o tesseract cuspir o resultado
    %x(tesseract -l por "#{filename}" output)
    %x(cat output.txt)
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
