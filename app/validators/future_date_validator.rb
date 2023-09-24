class FutureDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present? and value <= Time.zone.now
      message = options[:message] || :future_date
      record.errors.add(attribute, message)
    end
  end
end