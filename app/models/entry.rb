class Entry < ApplicationRecord
  belongs_to :author, class_name: "Member", foreign_key: "member_id"

  STATUS_VALUES = %w(draft member_only public)

  validates :title, presence: true, length: {maximum: 200}
  validates :body, :posted_at, presence: true
  validates :status, inclusion: {in: STATUS_VALUES}

  # 公開記事のみ
  scope :common, -> {where(status: "public")}
  # 下書き以外（公開・会員限定）
  scope :published, -> {where("status <> ?", "draft")}
  # 下書き以外と、自分が書いた記事全部
  scope :full, -> (member) {where("status <> ? OR member_id = ?", "draft", member.id)}
  # ログインしていればfull、していなければcommon
  scope :readable_for, -> (member) {member ? full(member) : common}

  class << self
    # statusを引数に、日本語文字列を取得する
    def status_text(status)
      I18n.t("activerecord.attributes.entry.status_#{status}")
    end

    # [["下書き", "draft"], ...]のような配列を作成する。画面上のリストに使用する。
    def status_options
      STATUS_VALUES.map {|status| [status_text(status), status]}
    end
  end

end
