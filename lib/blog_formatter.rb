require 'blog_formatter/basic_renderer'
require 'blog_formatter/truncator'

module BlogFormatter
  
  def truncate_html(string, limit=150)
    Truncator.new(string).truncate(limit)
  end
  
  def blog_format(text, text_format='htmlify')
    BasicRenderer.new(text_format).render(text)
  end
end
