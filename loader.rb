$AGORA_VAI_ROOT = Dir.pwd

load 'lib/naive_bayes.rb'
load 'lib/topic_classifier.rb'
load 'server/agora_vai.rb'

AgoraVai.run!
