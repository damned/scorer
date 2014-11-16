require 'ruboto/widget'
require 'ruboto/util/toast'

ruboto_import_widgets :Button, :LinearLayout, :TextView, :EditText

class ScorerActivity
  def onCreate(bundle)
    super
    set_title 'Scorer'

    self.content_view =
        linear_layout :orientation => :vertical do
          @text_view = text_view :text => 'Log your scores', :id => 42, 
                                 :layout => {:width => :match_parent},
                                 :gravity => :center, :text_size => 48.0
          @score_edit = edit_text(:single_line => true, :hint => "Score",
              :layout => {:width= => :fill_parent, :height= => :wrap_content, :weight= => 1.0},
              input_type: android.text.InputType::TYPE_CLASS_NUMBER)
          button :text => 'Log score', 
                 :layout => {:width => :match_parent},
                 :id => 43, :on_click_listener => proc { capture_score }
        end
  rescue Exception
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end

  private

  attr_reader :score_edit

  def capture_score
    File.open '/mnt/sdcard/scores.txt', 'a' do |f|
      score = score_edit.text.to_s 
      f.puts score + ', ' + Time.now.to_s
      toast "Logged score: #{score}"
    end
  end

end
