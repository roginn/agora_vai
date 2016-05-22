require 'sinatra/base'
require 'rubygems'
require 'sinatra'
require 'fileutils'
require 'pry'
load '../lib/naive_bayes.rb'
load '../lib/topic_classifier.rb'

class AgoraVai < Sinatra::Application
  get '/' do
    'PEIXE ESTEVE AQUI CARAJO!'
  end

  # upload with:
  # curl -v -F "data=@/path/to/filename"  http://localhost:4567/uploads/filename
  #escreve arquivo em agora_vai/uploads/filename
  post '/uploads/:filename' do
    userdir = File.join("uploads")
    FileUtils.mkdir_p(userdir)
    filename = File.join(userdir,params[:filename])
    datafile = params[:data]
  #  "#{datafile[:tempfile].inspect}\n"
    File.open(filename, 'wb') do |file|
      file.write(datafile[:tempfile].read)
    end
    "wrote to #{filename}\n"
  end

  post '/naive_bayes' do
    text = params[:data] || ''
    "#{predict(text)}\n"
  end


  def predict(text)
    tc = TopicClassifier.new
    tc.guess_class(text)
  end




  # start the server if ruby file executed directly
  run! if app_file == $0
end