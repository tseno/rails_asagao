class Admin::MembersController < Admin::Base

  def index
    @members = Member.order("number").page(params[:page]).per(15)
  end

  def show
    @member = Member.find(params[:id])
  end

  def new
    @member = Member.new(birthday: Date.new(1980, 1, 1))
  end

  def edit
    @member = Member.find(params[:id])
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      # 保存が成功したらshowにリダイレクトする。フラッシュ値を設定する。
      redirect_to [:admin, @member], notice: "会員を登録しました。"
    else
      # エラー発生時はnewに戻る
      render "new"
    end
  end

  def update
    @member = Member.find(params[:id])
    @member.assign_attributes(member_params)
    if @member.save
      # 保存が成功したらshowにリダイレクトする。フラッシュ値を設定する。
      redirect_to [:admin, @member], notice: "会員を更新しました。"
    else
      # エラー発生時はeditに戻る
      render "edit"
    end
  end

  private def member_params
    attrs = [
        :new_profile_picture,
        :remove_profile_picture,
        :number,
        :name,
        :full_name,
        :sex,
        :birthday,
        :email,
        :administrator
    ]
    # createの時は、:passwordを追加する
    attrs << :password if params[:action] == "create"

    params.require(:member).permit(attrs)
  end


  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    # 削除が成功したらindexにリダイレクトする。フラッシュ値を設定する。
    redirect_to :admin_members, notice: "会員を削除しました。"
  end

  def search
    @members = Member.search(params[:q]).page(params[:page]).per(15)
    render "index"
  end

end
