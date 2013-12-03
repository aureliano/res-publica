ResPublica::App.mailer :contato do
  
  email :email do |message|
    from         message.email
    to           ENV['EMAIL_USER_NAME']
    content_type :text
    subject      message.subject
    body         message.format_message
  end
  
end
