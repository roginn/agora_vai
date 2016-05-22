require 'watir'
require 'watir-webdriver'
require 'fileutils'

class Scraper
  HOME   = 'https://www.sprweb.com.br/mod_superpro/index.php'
  FOLDER = File.expand_path(File.join(File.dirname(__FILE__), 'questions'))

  def run
    browser = Watir::Browser.new
    browser.goto HOME

    credentials = YAML.load_file('account_agoravai_2d9662.yml')

    browser.text_field(name: 'LOGIN').set credentials['email']
    browser.text_field(name: 'SENHA').set credentials['password']
    browser.input(name: 'entrar').click
    browser.a(href: "javascript:redirect('FILTRO_QUESTAO');").click
    browser.span(text: 'Física').parent.parent.img(class: 'x-tree-ec-icon x-tree-elbow-plus').click

    sleep(5)

    # traverse tree ??
    browser.span(text: 'Termologia').parent.parent.img(class: 'x-tree-ec-icon x-tree-elbow-end-plus').click
    browser.span(text: 'Calorimetria').click
    topic = 'Calorimetria'
    # browser.span(text: topic).click

    browser.input(value: 'Visualizar questões >').click

    topic_dir = File.join(FOLDER, topic.gsub('/','-'))
    FileUtils.mkdir_p(topic_dir) unless Dir.exists?(topic_dir)

    total = browser.span(id: 'BOX_TOTAL_REG').text.to_i

    loop do
      numseq   = browser.input(id: 'NUM_SEQ').value().to_i
      filename = "#{browser.div(id: 'divInfoQ').font.text}.gif"

      src = browser.img(src: /data\:image\/gif.*/).src
      File.open(File.join(topic_dir, filename), 'wb') do |f|
        f.write(Base64.decode64(src.gsub('data:image/gif;base64,','')))
      end

      break if numseq == total || numseq > 200
      browser.input(id: 'btQuestaoPgPos').click
      sleep(5)
    end
  end
end
