# This class is meant to help divide the work of writing feature tests among a team of developers.
# We want to create Post It notes with the names of the controller actions to test but need to
# group actions with similar amounts of lines of code together so each Post It note lists roughly equal
# amounts of lines of code.
class ActionGrouper
  def initialize(reject_controllers)
    @reject_controllers = reject_controllers
  end

  def get_actions_divided_into_equal_groups(num_groups)
    controller_files   = get_controller_file_names
    controller_actions = get_lines_of_code_per_action controller_files
    flattened_actions  = flatten_controller_actions controller_actions

    grouping = divide_into_equal_groups flattened_actions, num_groups
    sorted_by_loc = grouping.sort_by { |_, actions| actions.values.sum }
    Hash[sorted_by_loc]
  end

  private

  def get_controller_file_names
    Dir.glob(Rails.root.join('app/controllers', '**/*.rb')).map do |path|
      path.split('/controllers/').last.sub '.rb', ''
    end.reject do |file_name|
      @reject_controllers.include? file_name
    end
  end

  # Get each controller's actions and lines of code per action:
  # e.g. { "controller" => [[:action1, line_count], [:action2, line_count], ...] }
  def get_lines_of_code_per_action(controller_files)
    controller_files.each_with_object({}) do |file_name, hash|
      controller_class = file_name.camelize.constantize
      actions = get_own_public_instance_methods controller_class, file_name
      
      hash[file_name] = actions.map do |action|
        [action, lines_of_code(action, controller_class).size]
      end
    end
  end

  # Flatten down to: { "controller_name#action" => line_count }
  def flatten_controller_actions(controller_actions)
    controller_actions.each_with_object({}) do |(controller, actions), hash|
      actions.each do |action, line_count|
        hash["#{controller}##{action}"] = line_count
      end
    end
  end

  # Equally dividing up actions so each group roughly gets assigned the same amount of total lines of code
  def divide_into_equal_groups(controller_actions, num_groups)
    total_lines      = controller_actions.values.sum
    lines_per_group  = total_lines / num_groups

    action_pile = controller_actions.dup

    grouping = num_groups.times.each_with_object({}) do |group_num, hash|
      line_count_in_group = 0

      while line_count_in_group <= lines_per_group
        action, line_count = action_pile.shift
        break if line_count.nil?

        hash[group_num] ||= {}
        hash[group_num][action] = line_count
        
        line_count_in_group += line_count
      end
    end

    grouping.merge! remaining: action_pile # include  whatever remains
  end

  def get_own_public_instance_methods(controller_class, file_name)
    file = File.read Rails.root.join('app/controllers', "#{file_name}.rb")
    # get the methods explicitly defined in this controller file
    own_methods = file.scan(/def ([a-z_!]+)$/).map &:first

    (controller_class.new.methods - ApplicationController.new.methods).reject do |action|
      action.to_s.starts_with?('_') || !own_methods.include?(action.to_s)
    end
  end

  def lines_of_code(action, controller_class)
    controller_class.new.method(action).source.lines
  end
end
