class LogsSearch
  include ActiveModel::Model

  attr_accessor :by, :term, :first_step

  validates :term, presence: true
  validate :validate_term

  def term
    @term&.strip
  end

private

  def validate_term
    case by
    when 'username'
      validate_username
    when 'ip'
      validate_ip
    end
  end

  def validate_username
    unless term.length == 5 || term.length == 6
      self.errors.add(:term, 'must be 5 or 6 characters')
    end
  end

  def validate_ip
    checker = UseCases::Administrator::CheckIfValidIp.new
    unless checker.execute(self.term)[:success]
      errors.add(:term, "must be a valid IP")
    end
  end
end
