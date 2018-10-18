class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title, null: false  # タイトル
      t.text :body, null: false  # 記事
      t.datetime :released_at, null:false  # 掲載開始日時
      t.datetime :expired_at  # 掲載終了日時
      t.boolean :member_only, null: false, default: false  # 会員のみフラグ
      t.timestamps null:false
    end
  end
end
