class LogsSearch
  include ActiveModel::Model

  attr_accessor :by, :term

  validates :term, presence: true
  validate :validate_term

  def initialize
    @by = 'username'
  end

private

  def validate_term
    validate_username if @by == 'username'
    validate_ip if @by == 'ip'
  end

  def validate_username
    unless @term.length == 5 || @term.length == 6
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
