class ContactMailer < ApplicationMailer
  def information_email
    mail(to: "info@d2cx.co.jp", subject: "new contact")
  end

  def contact_answer_email(contact, message,lang)

    @contentText = message
    @original = contact.content
    @origMail = contact.email
    oldLang = I18n.locale
    I18n.locale = lang
    mail(to: contact.email, subject: "Re: "+contact.title)
    I18n.locale = oldLang
  end
end
