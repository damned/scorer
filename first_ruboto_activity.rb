require 'ruboto/widget'
require 'ruboto/util/toast'

ruboto_import_widgets :Button, :LinearLayout, :TextView

# http://xkcd.com/378/

class FirstRubotoActivity
  def onCreate(bundle)
    super
    set_title 'Domo arigato, Mr Ruboto!'

    self.content_view =
        linear_layout :orientation => :vertical do
          @text_view = text_view :text => 'What hath Matz wrought?', :id => 42, 
                                 :layout => {:width => :match_parent},
                                 :gravity => :center, :text_size => 48.0
          @score = edit_text(:single_line => true, :hint => "Score",
              :layout => {:width= => :fill_parent, :height= => :wrap_content, :weight= => 1.0}
          button :text => 'Log score', 
                 :layout => {:width => :match_parent},
                 :id => 43, :on_click_listener => proc { capture_score }
          button :text => 'M-x butterfly', 
                 :layout => {:width => :match_parent},
                 :id => 43, :on_click_listener => proc { butterfly }
        end
  rescue Exception
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end

  private

  attr_reader :score

  def butterfly
    @text_view.text = 'What hath Matz wrought!'
    toast 'Flipped a bit via butterfly'
  end

  def capture_score
    File.open 'scores.txt', 'a' do |f|
      f.puts score
    end
  end

end
