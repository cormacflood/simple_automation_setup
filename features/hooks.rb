## frozen_string_literal: true
# require "active_support/all"
require "base64"
require "chunky_png"
require "colorize"
require "csv"
# The count that holds track of steps
@count = 0
$AlreadyLoggedIn = 0
$LC_AlreadyLoggedIn = 0
$user_id = 0

$profiles = []

# An array of steps that are active
STEPS = nil

# Runs before each scenario
Before do |scenario|

  $current_feature = scenario.feature.name

  # This allows us to retrieve the current page URL so we can parse and test it
  $world = self

  $start_time ||= Time.now
  log "Starting Scenario: ".blue + "#{scenario.location.file} ".blue + "- #{scenario.name} ℹ️".blue

  begin
    @count = 0
    STEPS = scenario.test_steps.reject { |step| step.to_s.include? "AfterStep hook" }
    log "Starting Step: " + "#{STEPS[@count]} ℹ️".yellow
  rescue StandardError => e
    log "Exception -> d #{e.message}", :error
    exit
  end

end

# Runs after each scenario
After do |scenario|

  if scenario.failed?
    take_screenshot
    log "Failed: ".red + "#{scenario.name} -".red + " #{STEPS[@count]} ❌".red
  else
    log "Scenario: ".green + "#{scenario.name}".blue + " Passed ✅".green
  end
end

# Runs after each step
AfterStep do |scenario|
  #sleep 1
  if scenario.to_s == "✓"
    log "Passed Step: " + "#{STEPS[@count]} ✅".green
    if ENV['SCREENSHOT'] == 'all_steps'
      take_screenshot
    end
  else
    log "Failed Step: " + "#{STEPS[@count]} ❌".red
    take_screenshot
  end

  begin
    @count += 1
    log "Starting Step:" + " #{STEPS[@count]} ℹ️".yellow unless STEPS[@count].nil?
  rescue StandardError => e
    log "Exception -> c #{e.message}", :error
    exit
  end

end

def take_screenshot
  $driver.save_screenshot("reports/screens/screenshot.png")
  scale_image(1)
  encoded_img = Base64.encode64(IO.read("reports/screens/screenshot_small.png"))
  embed("data:image/png;base64,#{encoded_img}", "image/png")
end

def scale_image(factor)
  begin
    image = ChunkyPNG::Image.from_file("reports/screens/screenshot.png")
    size = image.dimension.to_a
    image.resample_nearest_neighbor!(size[0] / factor, size[1] / factor)
    image.save("reports/screens/screenshot_small.png")
  rescue StandardError => e
    log "Error when scaling a screenshot: #{e}"
  end
end
