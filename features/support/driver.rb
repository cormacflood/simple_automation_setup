p "launching with Chrome" if ENV['BROWSER_TYPE'] == 'chrome'
p "launching with Firefox" if ENV['BROWSER_TYPE'] == 'firefox'
p "launching with Chrome" if !ENV['BROWSER_TYPE']
p "screenshotting FAILED steps ONLY" if !ENV['SCREENSHOT']
p "screenshotting ALL steps" if ENV['SCREENSHOT'] == 'all_steps'
p "screenshotting FAILED steps ONLY" if ENV['SCREENSHOT'] == 'fails_only'

BROWSER_DOWNLOAD_DIR = File.expand_path(File.join(File.dirname(__FILE__), '../../file_downloads'))
HEADLESS = (ENV['HEADLESS'] || nil)
p "ENV['HEADLESS'] is: "
p ENV['HEADLESS']
# A counter to keep track of browser launch attempts
@read_timeouts = 0

# configure the driver to run in headless mode
Selenium::WebDriver::Chrome.driver_path = ENV['CHROME_DRIVER_BIN'] if ENV['CHROME_DRIVER_BIN']

options = Selenium::WebDriver::Chrome::Options.new
ff_options = Selenium::WebDriver::Firefox::Options.new

options.binary = ENV['CHROME_BIN'] if ENV['CHROME_BIN']

puts BROWSER_DOWNLOAD_DIR
prefs = {
  default_directory: BROWSER_DOWNLOAD_DIR
  # default_directory: '/Users/cormacflood/workspace/syfl-newswire/qa/features/support/../../file_downloads'
  # default_directory: '/Users/cormacflood/workspace/syfl-newswire/qa/file_downloads'
}
options.add_preference(:download, prefs)
options.add_argument('--enable-logging --v=1')
options.add_argument("disable-infobars")
options.add_argument("no-sandbox")

if HEADLESS=="headless_execution"
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--ignore-certificate-errors')
  options.add_argument('--disable-popup-blocking')
  options.add_argument('--disable-translate')
 # options.add_argument('--disable-extensions')
  options.add_argument('--disable-sync')
  options.add_argument("--start-maximized")
  options.add_argument("--no-sandbox")
 # options.add_argument("--window-size=1680,1050")
  options.add_argument("disable-infobars")
  ff_options.add_argument("--headless")
  ff_options.add_argument("--no-sandbox")
end

ff_options.add_preference("browser.download.folderList", 2)
ff_options.add_preference("browser.download.manager.showWhenStarting", false)
ff_options.add_preference("browser.download.dir", BROWSER_DOWNLOAD_DIR)
ff_options.add_preference("browser.helperApps.neverAsk.saveToDisk", "video/mp4")

begin
  $driver = Selenium::WebDriver.for :chrome, options: options if ENV['BROWSER_TYPE'] == 'chrome'
  $driver = Selenium::WebDriver.for :firefox, options: ff_options if ENV['BROWSER_TYPE'] == 'firefox'
  $driver = Selenium::WebDriver.for :chrome, options: options if !ENV['BROWSER_TYPE']
rescue Net::ReadTimeout
  STDOUT.puts 'Net::ReadTimeout during browser launch. Trying to launch the browser again'.red
  self.close
  sleep 5
  @read_timeouts += 1
  unless @read_timeouts > 2
    $driver = Selenium::WebDriver.for :chrome, options: options if ENV['BROWSER_TYPE'] == 'chrome'
    $driver = Selenium::WebDriver.for :firefox, options: ff_options if ENV['BROWSER_TYPE'] == 'firefox'
    $driver = Selenium::WebDriver.for :chrome, options: options if !ENV['BROWSER_TYPE']
  end
end


screen_width = $driver.execute_script("return screen.width;")
screen_height = $driver.execute_script("return screen.height;")
$driver.manage.window.resize_to(screen_width, screen_height)

#$driver.manage.window.maximize

# $driver.manage.timeouts.page_load = 10 # seconds 
