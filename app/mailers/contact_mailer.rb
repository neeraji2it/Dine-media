class ContactMailer < ActionMailer::Base
  default :from => "donotreply@mail.dine-media.com"

  def contact(contact)
    @contact = contact
#    attachments.inline['photo.png'] = File.read("localhost:3000#{@contact.attach.url(:original)}")
    mail(:to =>"vivek@dine-media.com",:subject => @contact.subject , :from => @contact.email)
  end
end
