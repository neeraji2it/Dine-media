module ApplicationHelper
  def validation_error(message)
    if message.class.to_s == "Array"
      message = message.first
    end
    return !message.to_s.blank? ? ("<div class='form_error'>"+message.to_s+"</div>").html_safe : ""
  end
end
