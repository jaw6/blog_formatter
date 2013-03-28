require 'blog_formatter/custom_renderer'
require 'blog_formatter/redcloth_renderer'

class BlogFormatter::BasicRenderer
  attr_reader :format
  
  def initialize(format)
    @format   = format
  end
  
  def render(text)
    return '' unless text.present?
    return text if format == 'html'

    prepare!(text)
    renderer_for(@format).new.render text
  end
  
  private
  def renderer_for(format)
    {
      'htmlify'  => BlogFormatter::CustomRenderer,
      'redcloth' => BlogFormatter::RedClothRenderer
    }[format] or raise NotImplementedError.new("There is no #{format} renderer")
  end
  
  def prepare!(text)
    # Goofy old format links
    text.gsub!(%r{\[?link=([^\]]+)\]([^\[]+)\[/link\]}, '<a href="\1">\2</a>')
    # Link-ify plain http://www...
    text.gsub!(/(\s)(http\:|www.)([\S]+)(\s|$)/, '\1 <a href="\2\3">\2\3</a>\4')
    # Fix my old graphics directory...
    text.gsub!(%r{src="grfx/}, 'src="/images/grfx/')
    # Wrap long links?
    # doodad...
  end
end
