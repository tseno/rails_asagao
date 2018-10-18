class Member < ApplicationRecord
  has_secure_password

  has_many :entries, dependent: :destroy
  has_one_attached :profile_picture
  attribute :new_profile_picture
  attribute :remove_profile_picture, :boolean

  # numberのバリデート。nil,空,全角/半角空白禁止
  validates :number, presence: true,
    numericality: {
      # 整数のみ
      only_integer: true,
      # 0以上
      greater_than: 0,
      # 100未満
      less_than: 100,
      # presenceとの重複を避けるため
      allow_blank: true
    },
    # 重複禁止
    uniqueness: true
  # nameのバリデート。nil,空,全角/半角空白禁止
  validates :name, presence: true,
    # アルファベットから始まり、英数字のみ
    format: { with: /\A[A-Za-z][A-Za-z0-9]*\z/, allow_blank: true, message: :invalid_member_name },
    # 2文字以上20文字以下
    length: { minimum: 2, maximum: 20, allow_blank: true },
    # 重複禁止
    uniqueness: { case_sensitive: false }
  # full_nameのバリデート。nil,空,全角/半角空白禁止。20文字以下
  validates :full_name, presence: true, length: { maximum: 20 }
  # emailのバリデート
  validates :email, email: { allow_blank: true }

  attr_accessor :current_password
  validates :password, presence: { if: :current_password }

  validate if: :new_profile_picture do
    if new_profile_picture.respond_to?(:content_type)
      unless new_profile_picture.content_type.in?(ALLOWED_CONTENT_TYPES)
        errors.add(:new_profile_picture, :invalid_image_type)
      end
    else
      errors.add(:new_profile_picture, :invalid)
    end
  end

  before_save do
    if new_profile_picture
      self.profile_picture = new_profile_picture
      # self.profile_picture.attach(new_profile_picture) でも可
    elsif remove_profile_picture
      self.profile_picture.purge
    end
  end

  class << self
    def search(query)
      rel = order("number")
      if query.present?
        rel = rel.where("name LIKE ? OR full_name LIKE ?",
                        "%#{query}%", "%#{query}%")
      end
    end
  end
end
