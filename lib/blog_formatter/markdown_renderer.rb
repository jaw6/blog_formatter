require 'kramdown'

class BlogFormatter::MarkdownRenderer
  def render(text)
    Kramdown::Document.new(text).to_html.strip
  end

  private
  def fix(text)
    text
  end
end
