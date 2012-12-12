require "email_format_validator"
class Contact < ActiveRecord::Base
  attr_accessible :name,:email,:subject,:body, :attach
  has_attached_file :attach, :styles => {  :large => "640*480",  :medium => "300*300>",  :thumb => "100*100>" }
  validates :email, :presence => true, :email_format => true
  validates :name , :presence => true
  after_create :send_mail
  def send_mail
    ContactMailer.contact(self).deliver
  end
end
