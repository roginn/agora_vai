# load 'naive_bayes.rb'
require 'sqlite3'
require 'yaml'

class TopicClassifier
  UNACCENTER = [
    [/[áãâäàÁÃÂÄÀ]/, 'a'],
    [/[éẽêëèÉẼÊËÈ]/, 'e'],
    [/[íĩîïìÍĨÎÏÌ]/, 'i'],
    [/[óõôöòÓÕÔÖÒ]/, 'o'],
    [/[úũûüùÚŨÛÜÙ]/, 'u'],
    [/[çÇ]/, 'c']
  ]


  def initialize(categories = ['a', 'b'])
    @categories = categories
    stop_words_yaml = File.join($AGORA_VAI_HOME, 'stop_words.yml')
    stop_words = YAML.load(File.read(stop_words_yaml))['stop_words'].map { |w| sanitize_text w }
    @naive_bayes = NaiveBayes.new categories, stop_words
  end

  # def train!
  #   @categories.each do |category|
  #     example = sanitize_text File.read("../data/#{category}.txt")
  #     @naive_bayes.train category, example
  #   end
  #   @naive_bayes.filter_low_occurrences!
  # end

  def train!
    @db = SQLite3::Database.new(File.join $AGORA_VAI_HOME, "questions.db")
    records = @db.execute "select value, topic from questions;"
    records.each do |(value, topic)|
      example = sanitize_text value
      @naive_bayes.train topic, example
    end
  end

  def sanitize_text(raw_text)
    raw_text = raw_text.downcase.gsub("\n", ' ')
    UNACCENTER.each do |rule|
      from, to = rule
      raw_text.gsub! from, to
    end
    raw_text.gsub(/[^a-z0-9\s]/i,'')
  end

  def score(text)
    @naive_bayes.probabilities sanitize_text(text)
  end

  def guess_class(text)
    scores = score(text).select { |k, v| v < 0 } # eliminates Infinity
    scores.sort_by { |k, v| -v }[0][0]
  end
end
