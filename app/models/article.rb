class Article < ApplicationRecord
  validates :title, :body, :released_at, presence: true
  validates :title, length: {maximum: 80}
  validates :body, length: {maximum: 2000}

  def no_expiration
    expired_at.nil?
  end

  def no_expiration=(val)
    @no_expiration = val.in?([true, "1"])
  end

  before_validation do
    self.expired_at = nil if @no_expiration
  end

  # バリデーションの別の書き方。validatesではない。ブロック内に条件を自由に書くことができる。最後にerrorsにaddする。
  validate do
    if expired_at && expired_at < released_at
      errors.add(:expired_at, :expired_at_too_old)
    end
  end


  # メンバーのみではない（一般公開の記事）一覧を取得
  scope :open_to_the_public, -> {where(member_only: false)}

  # 掲載開始日時以降で、掲載終了日時以内か掲載終了日時が設定されていない記事一覧を取得
  scope :visible, -> do
    now = Time.current
    where("released_at <= ?", now).where("expired_at > ? OR expired_at IS NULL", now)
  end

end
