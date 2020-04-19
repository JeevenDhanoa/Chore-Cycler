
require 'net/smtp'
require 'dotenv/load'

class Resident
  attr_reader :name, :email, :chore

  def initialize(name, email, chore = "NA")
    self.name = name
    self.email = email
    self.chore = chore
  end

  def name=(a_name)
    (a_name == "")? raise("Name can't be blank!"): @name = a_name
  end

  def email=(an_email)
    (an_email == "")? raise("Email can't be blank!"): @email = an_email
  end

  def chore=(a_chore)
    (a_chore == "")? raise("Chore can't be blank!"): @chore = a_chore
  end

  def send_email(formatted_date)

    sender_email = ENV.fetch('sender_email')
    sender_email_password = ENV.fetch('sender_email_password')
    
    message = 
    "From: Chore Bot <#{sender_email}>
    \nTo: #{self.name} <#{self.email}>
    \nSubject: Chore Update for the week of #{formatted_date}!
    \nMIME-Version: 1.0
    \nContent-type: text/html

    \n<head>
      <style type = text/css>
        p { color:#500050;}
      </style>
      </head>

    \nHi #{self.name}! Your chore for this week is <b> #{self.chore}</b>. Chores will be updated next Monday morning!
    <br><br><hr>
    \n<p>
      This email was genereated automatically. View the source code for this project at https://github.com/JeevenDhanoa/Chore-Cycler. 
    </p>"

    smtp = Net::SMTP.new('smtp.gmail.com', 587)
    smtp.enable_starttls
    smtp.start('smtp.gmail.com', sender_email, sender_email_password, :login) do
      smtp.send_message(message, sender_email, self.email)
    end
  end

  def to_s
    return "Name: #{self.name}, Email: #{self.email}, Chore: #{self.chore} "
  end
end
