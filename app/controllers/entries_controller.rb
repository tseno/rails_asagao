class EntriesController < ApplicationController
  before_action :login_required, except: [:index, :show]

  def index
    if params[:member_id]
      # 会員IDがある場合は、その会員のブログ記事一覧
      @member = Member.find(params[:member_id])
      @entries = @member.entries
    else
      # 会員IDが無い場合は、全員のブログ記事一覧
      @entries = Entry.all
    end

    # ログイン中の会員が見られる記事に絞る。ページネーションも追加。
    @entries = @entries.readable_for(current_member).order(posted_at: :desc).page(params[:page]).per(3)

  end

  def show
    # ログイン中の会員が見られる記事のみ。idはブログ記事の主キー
    @entry = Entry.readable_for(current_member).find(params[:id])
  end

  def new
    @entry = Entry.new(posted_at: Time.current)
  end

  def edit
    # current_memberからentriesを取得している。一対多の関係があるため。
    @entry = current_member.entries.find(params[:id])
  end

  def create
    @entry = Entry.new(entry_params)
    @entry.author = current_member
    if @entry.save
      redirect_to @entry, notice: "記事を作成しました。"
    else
      render "new"
    end
  end

  def update
    @entry = current_member.entries.find(params[:id])
    @entry.assign_attributes(entry_params)
    if @entry.save
      redirect_to @entry, notice: "記事を更新しました。"
    else
      render "edit"
    end
  end

  private def entry_params
    params.require(:entry).permit(
        :member_id,
        :title,
        :body,
        :posted_at,
        :status
    )
  end

  def destroy
    @entry = current_member.entries.find(params[:id])
    @entry.destroy
    redirect_to :entries, notice: "記事を削除しました。"
  end

  # 投票
  def like
    @entry = Entry.published.find(params[:id])
    current_member.voted_entries << @entry
    redirect_to @entry, notice: "投票しました"
  end

  # 投票削除
  def unlike
    current_member.voted_entries.destroy(Entry.find(params[:id]))
    redirect_to :voted_entries, notice: "削除しました"
  end

  # 投票した記事一覧
  def voted
    @entries = current_member.voted_entries.published
                   .order("votes.created_at DESC")
                   .page(params[:page]).per(15)
  end

end
