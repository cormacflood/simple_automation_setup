require "selenium-webdriver"

# Base Screen contains things all child screens will use
class BaseScreen
  @wait_for_time = nil
  @driver = nil
  @id = nil

  def initialize(driver, timeout = 5)
    @driver = driver
    @wait_for_time = timeout
  end

  # Sets the default waitfor time
  # @param timeout [FixNum] timeout in seconds for the class
  def set_wait_for(timeout)
    @wait_for_time = timeout
  end

  # Waits until a block of code has completed or times out
  # @param block [Block] the block to wait for
  # @return [?] returns the result of the block execution
  def wait_until(&block)
    wait = Selenium::WebDriver::Wait.new timeout: @wait_for_time
    wait.until(&block)
  end

  # Checks if an element is NULL and returns FALSE
  # Simplifies checking (i.e. avoids 'not nil' etc)
  def checkIfExists(element_to_check)
    if element_to_check.nil?
      false
    else
      true
    end
  end

  def currentStoryID
    # https://newswire-demo2.storyful.com/qa/stories/214128?search_term=terrorist/unpublish
    url = current_page_url
    p current_page_url
    filter_part = url.split('stories/')[1]
    second_filter_part = filter_part.split('?')[0]
    p second_filter_part
    return second_filter_part
  end

  def currentCollectionID
    # https://newswire-demo2.storyful.com/qa/stories/214128?search_term=terrorist/unpublish
    url = current_page_url
    p current_page_url
    filter_part = url.split('collections/')[1]
    second_filter_part = filter_part.split('?')[0]
    p second_filter_part
    return second_filter_part
  end

  def getPageState
    @@body = $driver.find_element(:css, "body").text
  end

  def checkPageRefresh
    p "In checkPageRefresh"
    body = wait_to_find_element(:css, "body").text

    if body == @@body
      return nil
    else
      return false
    end
  end

  def current_page_url
    @@url = $driver.current_url
    return @@url
  end

  def check_url_is(url)
    
    if current_page_url.include? url
      return true
    end
    
  end

  # Finds an element via locator strategy
  # @param locator_strategy [Symbol] the method of search to use
  # @param locator [String] the locator string to search for
  # @return [Selenium::WebDriver::Element] the located element
  # @return [nil] if nothing was found
  def find_element(locator_strategy, locator)
    log "Searching for element by #{locator_strategy} using the following locator: #{locator} 🔍"
    @driver.find_element(locator_strategy, locator)
  rescue
    return nil
  end

  # Finds an array of elements via locator strategy
  # @param locator_strategy [Symbol] the method of search to use
  # @param locator [String] the locator string to search for
  # @return [Selenium::WebDriver::Element[]] Array of the located elements
  # @return [nil] if nothing was found
  def find_elements(locator_strategy, locator)
    log "Searching for elements by #{locator_strategy.to_s.cyan} using the following locator: #{locator.cyan} 🔍"
    @driver.find_elements(locator_strategy, locator)
  end

  # Waits a default timeout amount of time for an element to appear
  # @param locator_strategy [Symbol] the method of search to use
  # @param locator [String] the locator string to search for
  # @return [Selenium::WebDriver::Element] the located element
  # @return [nil] if nothing was found
  def wait_to_find_element(locator_strategy, locator)
    log "Waiting for the following" + "  ↓↓↓".light_red
    log "locator strategy is #{locator_strategy}"
    log "locator is #{locator}"
    start_time = Time.now
    begin
      element = wait_until { find_element(locator_strategy, locator) }
    rescue Selenium::WebDriver::Error::TimeoutError
      log "No matching element found!", :warn
      element = nil
    end
    end_time = Time.now

    total_time_string = log_time(start_time, end_time)
    log "Finished waiting for above " + "↑↑↑".light_red + " (Waited for #{total_time_string})"
    element
  end

  # Waits a default timeout amount of time for elements to appear
  # @param locator_strategy [Symbol] the method of search to use
  # @param locator [String] the locator string to search for
  # @return [Selenium::WebDriver::Element[]] the located elements
  # @return [nil] if nothing was found
  def wait_to_find_elements(locator_strategy, locator)
    log "Waiting for the following" + "  ↓↓↓".light_red
    start_time = Time.now
    begin
      elements = wait_until { find_elements(locator_strategy, locator) }
    rescue Selenium::WebDriver::Error::TimeoutError
      log "No matching elements found!", :warn
      elements = nil
    end
    end_time = Time.now

    total_time_string = log_time(start_time, end_time)
    log "Finished waiting for above " + "↑↑↑".light_red + " (Waited for #{total_time_string})"
    elements
  end

  # Finds an element via locator strategy as child of another element
  # @param element [Selenium::WebDriver::Element] the element to find a child of
  # @param locator_strategy [Symbol] the method of search to use
  # @param locator [String] the locator string to search for
  # @return [Selenium::WebDriver::Element] the located element
  # @return [nil] if nothing was found
  def find_sub_element(element, locator_strategy, locator)
    log "Searching for sub element by #{locator_strategy.to_s.cyan} using the following locator: #{locator.cyan} 🔍"
    element.find_element(locator_strategy, locator)
  end


  # Waits a default timeout amount of time for an element to appear as child of another element
  # @param element [Selenium::WebDriver::Element] the element to find a child of
  # @param locator_strategy [Symbol] the method of search to use
  # @param locator [String] the locator string to search for
  # @return [Selenium::WebDriver::Element] the located element
  # @return [nil] if nothing was found
  def wait_to_find_sub_element(element, locator_strategy, locator)
    log "Waiting for the following" + "  ↓↓↓".light_red
    start_time = Time.now
    begin
      element = wait_until { find_sub_element(element, locator_strategy, locator) }
    rescue Selenium::WebDriver::Error::TimeoutError
      log "No matching element found!", :warn
      element = nil
    end
    end_time = Time.now
    total_time_string = log_time(start_time, end_time)
    log "Finished waiting for above " + "↑↑↑".light_red + " (Waited for #{total_time_string})"
    element
  end

  # Waits a default timeout amount of time for elements to appear as child of another element
  # @param element [Selenium::WebDriver::Element] the element to find children of
  # @param locator_strategy [Symbol] the method of search to use
  # @param locator [String] the locator string to search for
  # @return [Selenium::WebDriver::Element[]] the located elements
  # @return [nil] if nothing was found
  def wait_to_find_sub_elements(element, locator_strategy, locator)
    log "Waiting for the following" + "  ↓↓↓".light_red
    start_time = Time.now
    elements = wait_until { find_sub_elements(element, locator_strategy, locator) }
    end_time = Time.now

    total_time_string = log_time(start_time, end_time)
    log "Finished waiting for above " + "↑↑↑".light_red + " (Waited for #{total_time_string})"
    elements
  end

  # taps an element
  # @param element [Selenium::WebDriver::Element] The element to click
  def tap_on(element)
    log "Tapping on element '#{element.name.to_s.cyan}' "
    begin
      element.click
    rescue StandardError => e
      log "An Error occurred while tapping on an element: #{e}", :error
    end
  end

  def click_on(element)
    begin
      response = element.click
    rescue
    end
    if !response.nil?
      if response.empty?
        p "firefox response type"
        return nil
      else
        return response
      end
    end
  end

  # hovers over an element
  def hover(element)
    $driver.action.move_to(element).perform
  end

  def send_keys_slowly(element, phrase, pause_time = 0.3)
    phrase_as_array = phrase.chars
    phrase_as_array.each do |a|
      element.send_keys(a)
      sleep(pause_time)
    end
    return nil
  end

  def scroll_into_view(element)
    $driver.execute_script("arguments[0].scrollIntoView(true);", element)
  end

  # Sends a string to an element
  # @param element [Selenium::WebDriver::Element] The element to type to
  # @param string [String] The string to type
  def send_keys(element, string)
    log "Sending '#{string.cyan}' to element '#{element.name.to_s.cyan}' ⌨️"
    begin
      element.send_keys(string)
      return nil
    rescue StandardError => e
      log "An Error occurred when trying to send keys to an element: #{e}"
    end
  end

  # Formats a string with colours representing how long it took to perform an action
  # @param start [Time] the start time of the action
  # @param finish [Time] the finish time of the action
  # @return [String] The formatted and coloured time string
  def log_time(start, finish)
    total_time = finish - start
    if total_time < 5
      Time.at(total_time).utc.strftime("%Mm, %Ss, %3Nms").to_s.green
    elsif total_time.between? 5, 10
      Time.at(total_time).utc.strftime("%Mm, %Ss, %3Nms").to_s.yellow
    elsif total_time > 10
      Time.at(total_time).utc.strftime("%Mm, %Ss, %3Nms").to_s.red
    end
  end

  # Clicks on a button containing the given text
  # @param text [String] The text written on the button
  # def click_on(text)
  #  wait_to_find_element(:xpath, "//input[@type='button' and @value='#{text}']").click
  # end

  # Tabs to the next textbox
  def tab_to_next_textbox
    $driver.action.send_keys(:tab).perform
  end

  #  # Generates a random string of lowercase letters
  # @param length [String] The length of the string to be generated
  def get_random_string(length)
    source = ("a".."z").to_a
    key = ""
    length.times { key += source[rand(source.size)].to_s }
    key
  end
end
