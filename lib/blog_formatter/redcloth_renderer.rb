class BlogFormatter::RedClothRenderer
  def render(text)
    redclothed = RedCloth.new(text)
    fix redclothed.to_html
  end
  
  private
  def fix(text)
    # no strikethrough 
    text.gsub!(%r{<del>(.*)</del>}, '\1')
    text.gsub!(%r{<blockquote>\s*<p>}, '<blockquote><p>')
    text.gsub!(%r{<blockquote>([^<]+)<p>}, '<blockquote><p>\1</p><p>')
    text
  end
end
