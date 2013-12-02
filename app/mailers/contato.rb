ResPublica::App.mailer :contato do
  
  email :email do |message|
    from         ENV['EMAIL_USER_NAME']
    to           message.email
    content_type :text
    subject      message.subject
    body         message.format_message
  end
  
end
