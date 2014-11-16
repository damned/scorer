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
                                 :gravity => :center, :text_size => 24.0
          @score_edit = edit_text(:single_line => true, :hint => "Score",
              :layout => {:width= => :fill_parent, :height= => :wrap_content, weight: 1.0},
              input_type: android.text.InputType::TYPE_CLASS_NUMBER)
          button :text => 'Log score', 
                 :layout => {:width => :match_parent},
                 :id => 43, :on_click_listener => proc { capture_score }
          @scores_text = text_view text: score_list
        end
  rescue Exception
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end

  private

  attr_reader :score_edit, :scores_text

  def capture_score
    File.open scores_filename, 'a' do |f|
      score = score_edit.text.to_s 
      f.puts score + ', ' + Time.now.to_s
      toast "Logged score: #{score}"
    end
    scores_text.text = score_list
  end

  def scores_filename
    '/mnt/sdcard/scores.txt' 
  end

  def score_list
    all_scores = scores
    list_size = 4
    list = all_scores.reverse.slice(0, list_size)
    list << "... and #{all_scores.size - list_size} others" if all_scores.size > list_size
    list.join "\n"
  end

  def scores
    File.readlines scores_filename
  end

end
