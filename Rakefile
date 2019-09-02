require "rubocop/rake_task"
require "rake/clean"
require "colorize"
require "json"
require "tacokit"

ENV['BROWSER_TYPE'] = 'chrome'
ENV['SCREENSHOT'] = 'fails_only'
ENV['HOST'] = 'https://newswire-staging.storyful.com'


task :default => [:build_framework]

desc "Part man Part machine All cop The future of code enforcement"
RuboCop::RakeTask.new(:rubocop) do |task|
  task.fail_on_error = true
end
task :rubo => [:rubocop]

desc "Generates the docs for the ruby code"
task :yard_gen do
  puts "GENERATING DOCS"
  puts system "yardoc"
end
task :doc => [:yard_gen]

desc "GIT Update - automation"
task :git_update do
  puts "UPDATING TO GIT HEAD".cyan
  puts system 'git pull'
end

desc "Runs a tag"
task :tag, [:tag_name, :staging_env, :browser, :on_the_down_low, :screenshots, :report_location, :cores, :demo_only_tests, :in_series_tests, :run_headless] do |_, args|
  args.with_defaults(tag_name: "@all")
  args.with_defaults(browser: "chrome")
  args.with_defaults(staging_env: "http://droptube-demo.storyful.com")
  args.with_defaults(on_the_down_low: "loud")
  args.with_defaults(screenshots: "fails_only")
  args.with_defaults(report_location: "reports/cucumber_report_builder")
  args.with_defaults(cores: "4")
  args.with_defaults(demo_only_tests: "no_demo_tests")
  args.with_defaults(in_series_tests: "parallel")
  args.with_defaults(run_headless: "no_headless_execution")
 

  current_branch_name = `git branch`
  current_branch_name[0] = ''

  #remove these for Dev machine only, restore for Mac Mini 
  # puts system 'pkill -f hrome'
  # puts system 'git pull --log'
  puts system 'rm -rf reports/json_reports_final'
  puts system 'mkdir reports/json_reports_final'

  #reset csv scenario tracking file
  puts system 'cat the_file.csv > file.csv'
  puts system 'rm -rf reports/json_reports/report*.json'
  
  puts system 'rm -rf rerun.txt'
  puts system "cucumber --retry 0 --tags #{args[:tag_name]} --format json -o reports/report99.json -e BROWSER_TYPE='#{args[:browser]}' TEST_HOST='#{args[:staging_env]}' SCREENSHOT='#{args[:screenshots]}' HEADLESS='#{args[:run_headless]}'"

  puts system 'cat the_file.csv > file.csv'


  puts system "report_builder -s reports/ -f html -o #{args[:report_location]} -T 'Regression: #{args[:staging_env]}, branch: #{current_branch_name}' -c blue"

  if args[:on_the_down_low] == "loud"
    # puts system "./send_report_to_slack.sh"
  end
end

desc "Runs all the steps you should run every morning"
task :refresh => [:git_update, :doc, :rubo]
