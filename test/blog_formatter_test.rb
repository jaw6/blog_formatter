require 'test_helper'

class BlogFormatterTest < ActiveSupport::TestCase

  class Foo
    include BlogFormatter
  end

  def setup
    @foo = Foo.new
  end

  test "truth" do
    assert_kind_of Module, BlogFormatter
  end
  
  test "truncate short should just return" do
    string = <<-STRING
    <p>This one is easy. It's super short.</p>
    STRING
    
    assert_equal "<p>This one is easy. It's super short.</p>", @foo.truncate_html(string)
  end
  
  test "truncate longer should end with ellisp" do
    string = <<-STRING
    <p>War will then confront me. I think of others by which this tariff taxation shall be diverted from this time existing in other improvements of agriculture, commerce, and navigation. I have used the words "they" and "their" in speaking of a war which might be affected.</p>
    STRING
    
    assert_equal "<p>War will then confront me. I think of others by which this tariff taxation shall be diverted from this time existing in other improvements of agriculture &hellip;</p>", @foo.truncate_html(string)
  end
  
  test "truncate should rejoin tags that get split" do
    string = <<-STRING
    <p>War will then confront me. I think of others by which this tariff taxation shall be diverted from this time existing in other <strong>improvements of agriculture, commerce, and navigation. I have used the</strong> words "they" and "their" in speaking of a war which might be affected.</p>
    STRING
    
    assert_equal "<p>War will then confront me. I think of others by which this tariff taxation shall be diverted from this time existing in other <strong>improvements of agriculture &hellip;</strong></p>", @foo.truncate_html(string)
  end
  
  test "truncate should remove empty tags" do
    string = medium_string
    assert_equal '<p>A group, <a href="http://www.pnhp.org">Physicians for a National Health Program</a>, has an interesting <a href="http://www.pnhp.org/news/2008/january/doctors_give_massach.php">press release</a>, distilled from an &#8220;open letter&#8221; signed by 250 doctors &hellip;</p>', @foo.truncate_html(string)
  end
  
  test "truncate should remove empty tags longer" do
    string = medium_string
    assert_equal '<p>A group, <a href="http://www.pnhp.org">Physicians for a National Health Program</a>, has an interesting <a href="http://www.pnhp.org/news/2008/january/doctors_give_massach.php">press release</a>, distilled from an &#8220;open letter&#8221; signed by 250 doctors in Massachussets. (I learned &hellip;</p>', @foo.truncate_html(string, 180)
  end
  
  test "truncate placement of ellipsis in funny ending blocks" do
    string = long_string
    assert_equal '<p>The &#8220;4 Things&#8221; meme:</p> <h4>Jobs I Have Had in My Life</h4> <ol> <li>Web Developer</li> <li>Temp</li> <li>Teaching Assistant</li> <li>Baby-sitter</li> </ol> <h4>Movies Seen More &hellip;</h4>', @foo.truncate_html(string, 160)
  end
  
  test "truncate should not include short strings" do
    string = long_string
    assert_equal '<p>The &#8220;4 Things&#8221; meme:</p> <h4>Jobs I Have Had in My Life</h4> <ol> <li>Web Developer</li> <li>Temp</li> <li>Teaching Assistant</li> <li>Baby-sitter</li> </ol> &hellip;', @foo.truncate_html(string)
  end

  test "htmlify with sample" do
    sample, expected = samples('htmlify_sample')
    result = @foo.blog_format(sample, 'htmlify')
    assert_equal result, expected
  end
  
  test "redcloth with sample" do
    sample, expected = samples('redcloth_sample')
    result = @foo.blog_format(sample, 'redcloth')
    assert_equal expected, result
  end
  
  test "html with sample" do
    sample, expected = ["<p>This is already formatted.</p>"] * 2
    result = @foo.blog_format(sample, 'html')
    assert_equal expected, result
  end
  
  private
  def get_sample(name)
    File.read File.join(Rails.root, '..', 'samples', "#{name}.txt")
  end

  def samples(name)
    input  = get_sample "input/#{name}"
    output = get_sample "output/#{name}"
    [input.strip, output.strip]
  end
  
  def medium_string
    @medium_string ||= get_sample "input/medium_sample"
  end
  
  def long_string
    @long_string ||= get_sample "input/long_sample"
  end

end
