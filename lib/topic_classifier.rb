# load 'naive_bayes.rb'
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

  STOP_WORDS_YAML = '../stop_words.yml'

  def initialize(categories = ['a', 'b'])
    @categories = categories
    stop_words = YAML.load(File.read(STOP_WORDS_YAML))['stop_words'].map { |w| sanitize_text w }
    @naive_bayes = NaiveBayes.new categories, stop_words
  end

  def train!
    @categories.each do |category|
      example = sanitize_text File.read("../data/#{category}.txt")
      @naive_bayes.train category, example
    end
    @naive_bayes.filter_low_occurrences!
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
    scores = score(text)
    scores.sort_by { |k, v| -v }[0][0]
  end
end
