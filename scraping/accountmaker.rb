require 'watir'
require 'watir-webdriver'

NEW_ACCOUNT_URL = 'https://www.sprweb.com.br/mod_superpro/index.php?PG=FORM_GRATIS'.freeze
SUPERPROFESSOR_TITLE = 'SuperPro Web'.freeze
MAILINATOR_TITLE = 'Mailinator'.freeze
WAIT_TIMEOUT = 2
MAIL_TITLE = /\s*Interbits - Superpro Web\s*/

def mailinator_url(inbox)
  "https://www.mailinator.com/inbox2.jsp?public_to=#{inbox}#/#public_maildirdiv"
end

nome = 'agoravai_' + SecureRandom.hex[0..5]
email = nome + '@mailinator.com'
password = SecureRandom.hex[0..6]

puts "nome = #{nome}"
puts "email = #{email}"
puts "password = #{password}"

begin
  browser = Watir::Browser.new
  browser.goto NEW_ACCOUNT_URL

  browser.text_field(name: 'NOME').set nome
  browser.text_field(name: 'EMAIL').set email
  # browser.text_field(name: 'CELULAR').set ''
  browser.select_list(name: 'PERFIL').select 'Professor'
  browser.input(name: 'button', id: 'button2').click
  browser.alert.ok

  browser.execute_script('window.open()')
  window2 = browser.window(title: '')
  window2.use do
    browser.goto mailinator_url(nome)
    puts " => Time.now: #{Time.now}"
    browser.div(id: 'public_maildirdiv').div(text: MAIL_TITLE).wait_until_present WAIT_TIMEOUT
    puts " => Time.now: #{Time.now}"
    puts "Timed out in #{WAIT_TIMEOUT}s waiting for email"
    browser.div(id: 'public_maildirdiv').div(text: MAIL_TITLE).click
    create_password_link = browser.element(:css, '[href^="http://click1.clickrouter.com/redirect?token="]').href
    puts "create_password_link = #{create_password_link}"
  end
  window2.close

  browser.goto create_password_link
  browser.input(name: 'PASSWD').set nome
  browser.input(name: 'CONF_PASSWD').set nome
  browser.input(name: 'entrar').click
ensure
  yaml = {
    'name' => nome || '',
    'email' => email || '',
    'create_password_link' => create_password_link || '',
    'password' => password || ''
  }.to_yaml

  File.open("account_#{nome}", 'w') { |file| file << yaml }
end
