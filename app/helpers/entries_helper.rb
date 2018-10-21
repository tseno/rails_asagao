module EntriesHelper
  # ブログのトップイメージ
  def the_first_image(entry)
    # 0番目のイメージを取得する
    image = entry.images.order(:position)[0]

    render_entry_image(image) if image
  end

  # ブログの2番目以降のイメージ
  def other_images(entry)
    buffer = "".html_safe
    # 2番目以降すべての画像を取得する。空の配列の場合はnilを返すため、ぼっち演算子&.が必要。
    entry.images.order(:position)[1..-1]&.each do |image|
      buffer << render_entry_image(image)
    end

    buffer
  end

  private def render_entry_image(image)
    content_tag(:div) do
      # 横が530ピクセルよりも大きい場合は、530ピクセルに画像を縮小する。
      image_tag image.data.variant(resize: "530x>"),
                alt: image.alt_text,
                style: "display: block; margin: 0 auto 15px"
    end
  end
end
