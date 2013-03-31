require 'blog_formatter'

class BlogFormatter::CustomRenderer
  def render(text)
    # Standardize line-breaks
    text.gsub!("\r\n", "\n")
    text.gsub!("\r", "\n")
    text.gsub!(" -- ", " &mdash; ")
    bad_html = %r{(p|ul|div|li|br|br /|blockquote|h1|h2|h3|h4|h5)}

    text.gsub!(%r|([^\n])\n<(#{bad_html})|, "\\1\n\n<\\2")
    text.gsub!(%r|</(#{bad_html}[^>]*)>\n([^\n])|, "</\\1>\n\n\\3")

    lines = text.split("\n\n")
    lines.each_with_index do |line,i|
      test_beg = (%r|^<#{bad_html}([^>]*)>.*$| =~ line)
      test_end = (%r|.*</#{bad_html}([^>]*)>$| =~ line)
      if !(test_beg && test_end)
        line.gsub!(/>(\n|\t| )*</, '> <')
        line.gsub!("\n", "<br />")
        line = "<p>#{line}</p>"
      end
      lines[i] = line
      #puts "#{i}: #{line}"
    end
    text = lines.join("\n\n")

    # Special: These are just tricky
    text.gsub!('<br /></blockquote></p>', '</p></blockquote>')
    text.gsub!('</blockquote></p>', '</p></blockquote>')
    text.gsub!('<p><blockquote><br />', '<blockquote><p>')
    text.gsub!('<p><blockquote>', '<blockquote><p>')
    text
  end
end
