class Expense < ApplicationRecord
  validates :category, presence: true
  validates :total, presence: true, numericality: true
  validates :paid_at, presence: true
  validate :total_can_not_be_smaller_than_zero

  belongs_to :owner, class_name: 'User', foreign_key: :user_id

  enum category: {
    apparel: 'apparel',
    entertainment: 'entertainment',
    grocery: 'grocery',
    meal: 'meal',
    utility: 'utility',
    other: 'other'
  }

  def tags_str=( tags )
    self[:tags] = convert_to_array( tags )
  end

  def tags_str
    convert_to_string( self[:tags] )
  end

  scope :owner, -> (user) { where(owner: user) }

  private

  def convert_to_array( raw_string, options = {} )
    options[:delimiter] ||= ';'
    return [] if raw_string.blank?
    raw_string.split(options[:delimiter]).map { |v|
      v.blank? ? nil : v.strip()
    }.compact
  end

  def convert_to_string( arrays, options = {} )
    return "" if arrays.nil? || (arrays.length == 0)
    options[:delimiter] ||= ';'
    arrays.join(options[:delimiter]).concat(';')
  end

  def total_can_not_be_smaller_than_zero
    if total.present? && total < 0
      errors.add(:total, "can't be smaller than 0")
    end
  end

end
