class Renderer
  def initialize(grouping)
    @grouping = grouping
    @remaining = @grouping.delete :remaining
    @template = File.read File.expand_path('../print_out.erb', __FILE__)
  end

  def render
    ERB.new(@template).result binding
  end

  def total_loc(actions)
    actions.values.sum
  end

  def compute_post_it_styles(actions)
    loc = total_loc actions
    color = compute_color(loc).join(',')

    {
      height: "#{compute_height}px;",
      'border-color' => "rgb(#{color});"
    }.map { |k, v| "#{k}:#{v} " }.join
  end

  private

  # Find the group with the most actions and return an int h where:
  # h = (max_actions + pad) * factor
  # the pad represents the top two header lines in the rendered post it
  # the factor represents the line height of the action list
  def compute_height(pad_lines = 2, factor = 18)
    (max_actions + pad_lines) * factor
  end

  # Make the groups with the least lines of code green and gradually go to red
  # return a string that will be parameters to the css rgb rule
  def compute_color(loc, blue = 0)
    min_loc = total_loc grouping_sorted_by_total_loc.first.last
    max_loc = total_loc grouping_sorted_by_total_loc.reverse.first.last
    
    range = max_loc - min_loc
    progress = loc - min_loc
    percent = progress.to_f / range.to_f * 255.0 # of the rgb range
    
    red = percent.ceil
    green = 255 - red

    [red, green, blue]
  end

  def max_actions
    @max_actions ||= grouping_sorted_by_action_count.reverse.first.last.size  
  end

  def grouping_sorted_by_action_count
    @grouping_sorted_by_action_count ||= @grouping.sort_by do |n, actions|
      actions.size
    end
  end

  def grouping_sorted_by_total_loc
    @grouping_sorted_by_total_loc ||= @grouping.sort_by do |n, actions|
      total_loc actions
    end
  end
end
