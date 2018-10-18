class LessonController < ApplicationController
  def step1
    render plain: "こんにちは、#{params[:name]}さん"
  end

  def step2
    render plain: params[:controller] + "#" + params[:action]
  end

  def step3
    redirect_to action: "step4"
    # redirect_to "/lesson/step4"
  end

  def step4
    render plain: "step4に移動しました。"
  end

  def step5
    # リダイレクション後のアクションで文字列を取り出すことができる。
    flash[:notice] = "step6に移動します。"
    redirect_to action: "step6"
  end

  def step6
    render plain: flash[:notice]
  end

  def step7
    # floorで小数点切り捨て
    @price = (2000 * 1.08).floor
  end

  def step8
    @price = 1000
    render "step7"  # step8ではなく、step7.html.erbでレンダリングする
  end

  def step9
    @comment = "<script>alert('危険！')</script>こんにちは。"
  end

  def step10
    @comment = "<strong>安全なHTML</strong>"
  end

  def step11
    @population = 704414
    @surface = 141.51
  end

  def step12
    @time = Time.current
  end

  def step13
    @population = 127767944
  end

  def step14
    @message = "ごきげんいかが？\nRailsの勉強がんばりましょう。"
  end

  def step17
    @zaiko = 10
  end

  def step18
    @items = {"フライパン" => 2680, "ワイングラス" => 2550, 
      "ペッパーミル" => 4515, "ピーラー" => 945}
  end
end
