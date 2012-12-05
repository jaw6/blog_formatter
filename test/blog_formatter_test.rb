require 'test_helper'

class BlogFormatterTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, BlogFormatter
  end

  def setup
    @strings = []
    @strings << <<-EOT
    <p>This one is easy. It's super short.</p>
    EOT
    @strings << <<-EOT
    <p>War will then confront me. I think of others by which this tariff taxation shall be diverted from this time existing in other improvements of agriculture, commerce, and navigation. I have used the words "they" and "their" in speaking of a war which might be affected.</p>
    EOT
    @strings << <<-EOT
    <p>War will then confront me. I think of others by which this tariff taxation shall be diverted from this time existing in other <strong>improvements of agriculture, commerce, and navigation. I have used the</strong> words "they" and "their" in speaking of a war which might be affected.</p>
    EOT
    @strings << <<-EOT
    <p>A group, <a href="http://www.pnhp.org">Physicians for a National Health Program</a>, has an interesting <a href="http://www.pnhp.org/news/2008/january/doctors_give_massach.php">press release</a>, distilled from an &#8220;open letter&#8221; signed by 250 doctors in Massachussets. (I learned about it from <a href="http://www.cjr.org/campaign_desk/mitts_health_plan_debunked.php?page=all"><span class="caps">CJR</span></a>, which says that it&#8217;s not getting any media coverage.)</p>

    <p>The ostensible goal of the program is to &#8220;provide residents with medical insurance&#8221;, that is, by <strong>requiring</strong> them to pay for health insurance. If they don&#8217;t, they will be fined. If they&#8217;re a certain distance below the poverty line, there&#8217;s a tax refund for the insurance. Employers who don&#8217;t provide health insurance to their employees are also fined.</p>
    EOT
    
    @strings << <<-EOT
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
    EOT
  end
  
  def test_truncate_short_should_just_return
    string = @strings[0]
    assert_equal "<p>This one is easy. It's super short.</p>", BlogFormatter.truncate_html(string)
  end
  
  def test_truncate_longer_should_end_with_ellisp
    string = @strings[1]
    assert_equal "<p>War will then confront me. I think of others by which this tariff taxation shall be diverted from this time existing in other improvements of agriculture &hellip;</p>", BlogFormatter.truncate_html(string)
  end
  
  def test_truncate_should_rejoin_tags_that_get_split
    string = @strings[2]
    assert_equal "<p>War will then confront me. I think of others by which this tariff taxation shall be diverted from this time existing in other <strong>improvements of agriculture &hellip;</strong></p>", BlogFormatter.truncate_html(string)
  end
  
  def test_truncate_should_remove_empty_tags
    string = @strings[3]
    assert_equal '<p>A group, <a href="http://www.pnhp.org">Physicians for a National Health Program</a>, has an interesting <a href="http://www.pnhp.org/news/2008/january/doctors_give_massach.php">press release</a>, distilled from an &#8220;open letter&#8221; signed by 250 doctors &hellip;</p>', BlogFormatter.truncate_html(string)
  end
  
  def test_truncate_should_remove_empty_tags_longer
    string = @strings[3]
    assert_equal '<p>A group, <a href="http://www.pnhp.org">Physicians for a National Health Program</a>, has an interesting <a href="http://www.pnhp.org/news/2008/january/doctors_give_massach.php">press release</a>, distilled from an &#8220;open letter&#8221; signed by 250 doctors in Massachussets. (I learned &hellip;</p>', BlogFormatter.truncate_html(string, 180)
  end
  
  def test_truncate_placement_of_ellipsis_in_funny_ending_blocks
    string = @strings[4]
    assert_equal '<p>The &#8220;4 Things&#8221; meme:</p> <h4>Jobs I Have Had in My Life</h4> <ol> <li>Web Developer</li> <li>Temp</li> <li>Teaching Assistant</li> <li>Baby-sitter</li> </ol> <h4>Movies Seen More &hellip;</h4>', BlogFormatter.truncate_html(string, 160)
  end
  
  def test_truncate_should_not_include_short_strings
    string = @strings[4]
    assert_equal '<p>The &#8220;4 Things&#8221; meme:</p> <h4>Jobs I Have Had in My Life</h4> <ol> <li>Web Developer</li> <li>Temp</li> <li>Teaching Assistant</li> <li>Baby-sitter</li> </ol> &hellip;', BlogFormatter.truncate_html(string)
  end

end
