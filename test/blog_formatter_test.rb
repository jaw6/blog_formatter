require 'test_helper'

class BlogFormatterTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, BlogFormatter
  end

  def setup
  end
  
  test "truncate short should just return" do
    string = <<-STRING
    <p>This one is easy. It's super short.</p>
    STRING
    
    assert_equal "<p>This one is easy. It's super short.</p>", BlogFormatter.truncate_html(string)
  end
  
  test "truncate longer should end with ellisp" do
    string = <<-STRING
    <p>War will then confront me. I think of others by which this tariff taxation shall be diverted from this time existing in other improvements of agriculture, commerce, and navigation. I have used the words "they" and "their" in speaking of a war which might be affected.</p>
    STRING
    
    assert_equal "<p>War will then confront me. I think of others by which this tariff taxation shall be diverted from this time existing in other improvements of agriculture &hellip;</p>", BlogFormatter.truncate_html(string)
  end
  
  test "truncate should rejoin tags that get split" do
    string = <<-STRING
    <p>War will then confront me. I think of others by which this tariff taxation shall be diverted from this time existing in other <strong>improvements of agriculture, commerce, and navigation. I have used the</strong> words "they" and "their" in speaking of a war which might be affected.</p>
    STRING
    
    assert_equal "<p>War will then confront me. I think of others by which this tariff taxation shall be diverted from this time existing in other <strong>improvements of agriculture &hellip;</strong></p>", BlogFormatter.truncate_html(string)
  end
  
  test "truncate should remove empty tags" do
    string = medium_string
    assert_equal '<p>A group, <a href="http://www.pnhp.org">Physicians for a National Health Program</a>, has an interesting <a href="http://www.pnhp.org/news/2008/january/doctors_give_massach.php">press release</a>, distilled from an &#8220;open letter&#8221; signed by 250 doctors &hellip;</p>', BlogFormatter.truncate_html(string)
  end
  
  test "truncate should remove empty tags longer" do
    string = medium_string
    assert_equal '<p>A group, <a href="http://www.pnhp.org">Physicians for a National Health Program</a>, has an interesting <a href="http://www.pnhp.org/news/2008/january/doctors_give_massach.php">press release</a>, distilled from an &#8220;open letter&#8221; signed by 250 doctors in Massachussets. (I learned &hellip;</p>', BlogFormatter.truncate_html(string, 180)
  end
  
  test "truncate placement of ellipsis in funny ending blocks" do
    string = long_string
    assert_equal '<p>The &#8220;4 Things&#8221; meme:</p> <h4>Jobs I Have Had in My Life</h4> <ol> <li>Web Developer</li> <li>Temp</li> <li>Teaching Assistant</li> <li>Baby-sitter</li> </ol> <h4>Movies Seen More &hellip;</h4>', BlogFormatter.truncate_html(string, 160)
  end
  
  test "truncate should not include short strings" do
    string = long_string
    assert_equal '<p>The &#8220;4 Things&#8221; meme:</p> <h4>Jobs I Have Had in My Life</h4> <ol> <li>Web Developer</li> <li>Temp</li> <li>Teaching Assistant</li> <li>Baby-sitter</li> </ol> &hellip;', BlogFormatter.truncate_html(string)
  end
  
  private
  def medium_string
    @medium_string ||= <<-STRING
    <p>A group, <a href="http://www.pnhp.org">Physicians for a National Health Program</a>, has an interesting <a href="http://www.pnhp.org/news/2008/january/doctors_give_massach.php">press release</a>, distilled from an &#8220;open letter&#8221; signed by 250 doctors in Massachussets. (I learned about it from <a href="http://www.cjr.org/campaign_desk/mitts_health_plan_debunked.php?page=all"><span class="caps">CJR</span></a>, which says that it&#8217;s not getting any media coverage.)</p>

    <p>The ostensible goal of the program is to &#8220;provide residents with medical insurance&#8221;, that is, by <strong>requiring</strong> them to pay for health insurance. If they don&#8217;t, they will be fined. If they&#8217;re a certain distance below the poverty line, there&#8217;s a tax refund for the insurance. Employers who don&#8217;t provide health insurance to their employees are also fined.</p>
    STRING
  end
  
  def long_string
    @long_string ||= <<-STRING
    <p>The &#8220;4 Things&#8221; meme:</p>

    <h4>Jobs I Have Had in My Life</h4>
  	<ol>
    	<li>Web Developer</li>
  		<li>Temp</li>
  		<li>Teaching Assistant</li>
  		<li>Baby-sitter</li>
  	</ol>

  	<h4>Movies Seen More Than Once</h4>
  	<ol>
    	<li>Shaun of the Dead</li>
  		<li>Idiocracy</li>
  		<li>Star Wars</li>
  		<li>The Incredibles</li>
  	</ol>
    STRING
  end

end
