class LogsSearch
  include ActiveModel::Model

  attr_accessor :filter, :first_step
  attr_writer :term

  validate :validate_term, :validate_presence

  def term
    @term&.strip
  end

private

  def validate_term
    case filter
    when 'username'
      validate_username
    when 'ip'
      validate_ip
    end
  end

  def validate_presence
    self.errors.add(:search_term, 'cannot be empty') if term.empty?
  end

  def validate_username
    if term_is_present_but_incorrect_length
      self.errors.add(:search_term, 'must be 5 or 6 characters')
    end
  end

  def term_is_present_but_incorrect_length
    term.present? && term.length != 5 && term.length != 6
  end

  def validate_ip
    validate_presence if term.empty? && return

    checker = UseCases::Administrator::CheckIfValidIp.new
    unless checker.execute(self.term)[:success]
      errors.add(:search_term, 'must be a valid IP address')
    end
  end
end
