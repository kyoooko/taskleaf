class Task < ApplicationRecord
  before_validation :set_nameless_name # コールバック

  validates :name, presence: true, length: { maximum: 30 } # バリデーション
  validate :validate_name_not_including_comma # バリデーションは自分でも作れる(sいらない)

  belongs_to :user

  # スコープ（データの絞り込みの②絞り込み部分をまとめられるもの）
  # スコープ使わないとコントローラで@tasks =current_user.tasks.order(created_at: :desc)と書く
  # 使うとTask.recentのように使える
  # scope :recent, -> {order(created_at: :desc)

  # ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private
  def validate_name_not_including_comma
    errors.add(:name,'にコンマを含めることができません。') if name&.include?(',')
  end
  def set_nameless_name
    self.name='名前なし' if name.blank?   # コールバック
  end
end
