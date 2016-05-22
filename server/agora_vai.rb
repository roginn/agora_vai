require 'sinatra/base'
require 'rubygems'
require 'sinatra'
require 'fileutils'
require 'pry'
require 'base64'


require_relative '../lib/naive_bayes.rb'
require_relative '../lib/topic_classifier.rb'

class AgoraVai < Sinatra::Application

  AGORA_VAI_HOME = File.expand_path(File.join('..', File.dirname(__FILE__)))

  get '/' do
    'ALL HAIL ETEVALDO'
  end

  # upload with:
  # curl -v -F "data=@/path/to/filename"  http://localhost:4567/uploads/filename
  #escreve arquivo em agora_vai/uploads/filename
  post '/uploads/:filename' do
    logger.info '*************************'
    logger.info params.inspect
    userdir = File.join(AGORA_VAI_HOME, "uploads")
    FileUtils.mkdir_p(userdir) unless Dir.exists?(userdir)
    filename = File.join(userdir,params[:filename])
    datafile = params[:data]
  #  "#{datafile[:tempfile].inspect}\n"
    File.open(filename, 'wb') do |file|
      file.write(Base64.decode64(datafile))
    end

    # mandando o tesseract cuspir o resultado
    %x(tesseract -l por "#{filename}" output)
    output = %x(cat output.txt)

    logger.info output.inspect
    "#{predict(output)}\n"
  end

  post '/naive_bayes' do
    text = params[:data] || ''
    "#{predict(text)}\n"
  end


  def predict(text)
    tc = TopicClassifier.new %w{
      calorimetria
      dimensional
      eletricidade
      magnetismo
      mecanica
      moderna
      ondulatoria
      optica
    }
    tc.train!
    # tc.score(text).to_s
    tc.guess_class(text)
  end



  # start the server if ruby file executed directly
  run! if app_file == $0
end
