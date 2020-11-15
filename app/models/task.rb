class Task < ApplicationRecord
  before_validation :set_nameless_name # コールバック
  validates :name, presence: true, length: { maximum: 30 } # バリデーション
  validate :validate_name_not_including_comma # バリデーションは自分でも作れる(sいらない)

  private
  def validate_name_not_including_comma
    errors.add(:name,'にコンマを含めることができません。') if name&.include?(',')
  end
  def set_nameless_name
    self.name='名前なし' if name.blank?   # コールバック
  end
end
