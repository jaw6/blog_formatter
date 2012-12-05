module BlogFormatter
  extend self
  
  def close_tags(code)
    open_tags = {}
    closed_tags = {}
    code.scan(/\<([^\>\s\/]+)[^\>\/]*?\>/).each { |t| open_tags[t[0]] ? open_tags[t[0]] += 1 : open_tags[t[0]] = 1 }
    code.scan(/\<\/([^\>\s\/]+)[^\>]*?\>/).each { |t| closed_tags[t[0]] ? closed_tags[t[0]] += 1 : closed_tags[t[0]] = 1 }
    open_tags.each {|k,v| code += "</#{k}>" * (open_tags[k] - closed_tags[k].to_i) if closed_tags[k].to_i < v }
    return code
  end
  
  def limited_html(string, limit)
    counter = 0
    new_string = ''
    stopped = false
    string.split(/>/).each do |chunk|
      if counter >= limit
        stopped = true
        break
      end
      if chunk =~ /^</ # if this is a closing tag, just close it
        new_string << chunk + '>'
      else
        nontagpart = chunk.split(/</).first
        # if the non-tag portion of the chunk is smaller than the remaining limit, just add it
        if (counter + nontagpart.size) < limit 
          counter += nontagpart.size
          new_string << chunk + '>'
        else
          potential = ''
          for word in nontagpart.split(/\s/)
            if counter < limit 
              counter += word.size + 1
              potential << word + ' '
            else
              stopped = true
              # don't add this, unless it's meaty
              new_string << potential unless potential.size < 10 
              break
            end
          end
        end
      end
    end
    new_string = new_string.gsub(/[,.;-]\s*$/, ' ').gsub(/\s+/, ' ') # remove trailing punctuation & excess whitespace
    new_string = new_string.gsub(%r{<[^/]+>$}, '') # remove the last open tag if any
    new_string += '&hellip;' if stopped # add an ellipsis if we stopped early
    close_tags(new_string)
  end
  
  def no_paras(string)
    string = string[3..-1] if string[0..2] == '<p>'
    string = string[0..-5] if string[-4..-1] == '</p>'
    string
  end
  
  def truncate_html(string, limit=150)
    string = string.strip
    return string if string.size <= limit
    limited = limited_html(string, limit)
    return limited
  end
  
end
