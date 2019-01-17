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
    if term.length == 0
      self.errors.add(:search_term, 'cannot be empty')
    end
  end

  def validate_username
    unless term.length == 5 || term.length == 6 || term.length == 0
      self.errors.add(:search_term, 'must be 5 or 6 characters')
    end
  end

  def validate_ip
    validate_presence if term.length == 0 && return

    checker = UseCases::Administrator::CheckIfValidIp.new
    unless checker.execute(self.term)[:success]
      errors.add(:search_term, 'must be a valid IP address')
    end
  end
end
