class UserMailer < ActionMailer::Base
  def send_email
    puts "ok"
    data = ""
    user = User.order(ranking: :desc)
    user.each do |u|
      data += u.email
      puts u.email
    end
    File.open("teston", 'w') { |file| file.write(data) }
  end
end
