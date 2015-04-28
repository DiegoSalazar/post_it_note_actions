require 'post_it_note_actions/action_grouper'
require 'post_it_note_actions/renderer'

REJECT_CONTROLLERS = %w[application_controller]

desc "Generate a list of controller actions grouped by their lines of code count"
task :post_it_note_actions, [:num_groups, :output_file] => :environment do |task, args|
  num_groups = (args[:num_groups] || 10).to_i
  output_file = args[:output_file] || Rails.root.join('post_it_note_test.html')

  grouper = ActionGrouper.new REJECT_CONTROLLERS
  grouping = grouper.get_actions_divided_into_equal_groups num_groups
  html = Renderer.new(grouping).render

  File.open(output_file, 'w') { |f| f.write html }
  puts "\aDone. Wrote HTML file to: #{output_file}"
  system "open #{output_file}"
end
