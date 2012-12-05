module BlogFormatter
    
  class TruncatableHtml < Struct.new(:html_string)
    def truncate(length=150)
      prepare!
      return html_string if html_string.size <= length
      truncate_to(length)
    end
    
    private
    def truncate_to(length)
      new_string, needs_ellipsis = truncate_by_chunking(length)

      # remove trailing punctuation & excess whitespace
      new_string = new_string.gsub(/[,.;-]\s*$/, ' ').gsub(/\s+/, ' ') 

      # remove the last open tag if any
      new_string = new_string.gsub(%r{<[^/]+>$}, '')
      
      # add an ellipsis if we stopped early
      new_string += '&hellip;' if needs_ellipsis 
      
      close_tags(new_string)
    end
    
    def truncate_by_chunking(length)
      counter    = 0
      stopped    = false
      new_string = ''

      html_string.split(/>/).each do |chunk|
        if counter >= length
          stopped = true
          break
        end
        if chunk =~ /^</ # if this is a closing tag, just close it
          new_string << chunk + '>'
        else
          nontagpart = chunk.split(/</).first
          # if the non-tag portion of the chunk is smaller than the remaining length, just add it
          if (counter + nontagpart.size) < length 
            counter += nontagpart.size
            new_string << chunk + '>'
          else
            potential = ''
            for word in nontagpart.split(/\s/)
              if counter < length 
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

      [new_string, stopped]
    end

    def close_tags(code)
      open_tags = []

      code.scan(/\<([^\>\s\/]+)[^\>\/]*?\>/).each { |tags| open_tags += tags }

      open_tags.reverse!

      code.scan(/\<\/([^\>\s\/]+)[^\>]*?\>/).each do |tags|
        tag = tags.first
        raise ArgumentError unless tags.size == 1
        if i = open_tags.index { |item| item == tag }
          open_tags.delete_at i
        end
      end

      code += open_tags.map { |tag| "</#{tag}>" }.join

      return code
    end

    def no_paras(string)
      string = string[3..-1] if string[0..2] == '<p>'
      string = string[0..-5] if string[-4..-1] == '</p>'
      string
    end

    def prepare!
      html_string.strip!
    end
  end
  
  def self.truncate_html(string, limit=150)
    TruncatableHtml.new(string).truncate(limit)
  end
  
end
