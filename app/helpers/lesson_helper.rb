module LessonHelper
  def tiny_format(text)
    # hメソッドはHTML特殊文字を変換する（<>'等）
    # gsubは正規表現の置換を行う
    # html_safeは<br />をそのまま出力する
    h(text).gsub("\n","<br />").html_safe
  end
end
