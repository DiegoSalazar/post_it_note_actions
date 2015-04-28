# PostItNoteActions

Legacy code is tough to change and update. Legacy code with no test coverage is even harder. In an attempt to make the process of writing tests for a monolithic app a little more fun I created this gem.

The idea is to make writing tests a bit competitive and have visual feedback for the dev team on overall testing progress. So we came up with this Post It Note Board idea where we'd write all the controller actions that need test coverage on Post It Notes and put them up on the board. As each dev finishes writing tests for the actions on the Post It Note they grabbed they can then put them under a column with their name on it.

We needed a way to keep the same controllers roughly grouped together so each dev can work on their own test file. Also, each Post It Note should represent equal amounts of work. To do this, we count each action's lines of code, then cap the max total lines of code per Post It Note depending on how many total lines of code across all actions divided by how many devs are on the team. 

The result is an HTML page with boxes listing the controller name and action and the total lines of code for that Post It Note.

Then, print out the resulting HTML file, which is written to your project root, and cut out the Post Its!. Make a column for each of your dev's names. Each column can have a "Working" and "Done" sub column to allow other devs to see who is working on which actions in case they get a Post It with overlapping controllers.

![Image of Example Post It Note Board](https://cloud.githubusercontent.com/assets/89930/7376906/1672368e-edb1-11e4-917c-f95139327df3.jpg)

Funny how this project doesn't have tests, as you may have noticed. I'm too busy! After writing this project and running it against our legacy Rails app, we ended up printing out 100 Post Its, each with about 80 lines of code! 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'post_it_note_actions'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install post_it_note_actions

## Usage

This gem exposes a single rake task that takes 2 arguments:

```
rake post_it_note_actions[10,"output file name.html"]
```

The first argument is the max number of post it notes to print out. Depending on how many controller actions your project has you should vary that number so that each Post It Note has a decent amount of actions and lines of code.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/DiegoSalazar/post_it_note_actions/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
