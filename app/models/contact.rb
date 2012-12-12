require "email_format_validator"
class Contact < ActiveRecord::Base
  attr_accessible :name,:email,:subject,:body, :attach, :attach_file_name, :attach_content_type, :attach_file_size, :attach_updated_at
  has_attached_file :attach, :styles => {  :large => "640*480",  :medium => "300*300>",  :thumb => "100*100>" }
  validates :email, :presence => true, :email_format => true
  validates :name , :presence => true
#  validates_format_of :attach_file_name, :with => %r{\.(docx|doc|pdf)$}i,
#    :message => 'Only PDF, doc, docx or TEXT files are allowed. '
#   validates_attachment_presence :attach
  validates_attachment_content_type :attach, :content_type => ['application/pdf', 'text/plain'], :if => Proc.new { |module_file| !module_file.attach_file_name.blank? }, :message => "must be in '.pdf' format"
  after_create :send_mail
  def send_mail
    ContactMailer.contact(self).deliver
  end
end
