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
password = SecureRandom.hex[0..9]
create_password_link = '_BLANK_'
running_result = 'error'

puts "nome = #{nome}"
puts "email = #{email}"
puts "password = #{password}"

def try_element(browser, timeout: WAIT_TIMEOUT)
  puts 'Trying web element...'
  puts " => Time.now: #{Time.now}"
  begin
    (yield browser).wait_until_present timeout
  rescue Watir::Wait::TimeoutError
    puts "Timed out in #{WAIT_TIMEOUT}s waiting for element"
  ensure
    puts " => Time.now: #{Time.now}"
  end
  (yield browser)
end

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
    email_link = try_element(browser) { |b| b.div(class: 'innermail', text: MAIL_TITLE) }
    email_link.click
    link = try_element(browser) do |b|
      b.iframe(id: 'publicshowmaildivcontent').a(:css, '[href^="http://click1.clickrouter.com/redirect?token="]')
    end
    create_password_link = link.href
    puts "create_password_link = #{create_password_link}"
  end
  window2.close

  browser.goto create_password_link
  browser.input(id: 'PASSWD').send_keys password
  browser.input(id: 'CONF_PASSWD').send_keys password
  browser.input(name: 'entrar').click
  running_result = 'success'
ensure
  browser.close rescue nil

  yaml = {
    'name' => nome,
    'email' => email,
    'create_password_link' => create_password_link,
    'password' => password,
    'running_result' => running_result
  }.to_yaml

  File.open("account_#{nome}.yml", 'w') { |file| file << yaml }
end
