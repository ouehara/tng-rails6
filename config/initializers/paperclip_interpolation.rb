require "globalize"
require "paperclip"

Paperclip.interpolates(:locale) do |attachment, _style_name|
  if(Globalize.locale == :en)
    return ""
  end
  record = attachment.instance
  file_name_attr = "#{attachment.name}_file_name"
  attachment_locale =
    if record.respond_to?(:translation) && record.translated?(file_name_attr)
      # determine via metadata if activated (I18n::Backend::Simple.include(I18n::Backend::Metadata))
      if record.send(file_name_attr).respond_to?(:translation_metadata)
        record.send(file_name_attr).translation_metadata[:locale]
      else # determine via globalize fallback configuration

        #||  record.globalize_fallbacks(Globalize.locale)
        if record.translation_for(Globalize.locale).respond_to?(file_name_attr)
          check = record.translation_for(Globalize.locale).send(file_name_attr) == nil ||record.translation_for(Globalize.locale).send(file_name_attr) == ""
        else
          check = true
        end
        if check
          ""
        else
          (record.globalize_fallbacks(Globalize.locale) & record.translated_locales).first 
        end
      end
    else
      Rails.logger.warn(
        "WARN You have used :locale in a paperclip url/path for an untranslated model (in #{record.class.to_s})."
      )
      nil
    end
    (attachment_locale || Globalize.locale).to_s
end