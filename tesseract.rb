require 'sqlite3'

db = SQLite3::Database.new "questions.db"

rows = db.execute <<-SQL
  -- DROP TABLE IF EXISTS questions;

  CREATE TABLE questions (
    id integer PRIMARY KEY AUTOINCREMENT,
    value varchar(1000),
    topic varchar(30)
  );
SQL

def remove_question_options(text)
  text.gsub(/a\)[\S\s]*/,'')
end

files = Dir['scraping/questions/*/**']
# as per https://gist.github.com/henrik/1967035
files.each do |file|
  _, _, topic, _ = file.split('/')
  %x(convert "#{file}" -resize 400% -type Grayscale input.tif)
  %x(tesseract -l por input.tif output)

  db.execute(%Q{
    INSERT INTO questions (value, topic) VALUES (?, ?)
  }, [remove_question_options(File.read('output.txt')), topic])
end
