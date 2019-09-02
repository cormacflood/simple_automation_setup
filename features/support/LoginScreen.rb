# Basic model for the login screen
class LoginScreen < BaseScreen
  # Locators for elements available on the Login Screen
  LOCATORS = {

      id: {
          username_textbox: "user_email",
          password_textbox: "user_password"

      },
      name: {
          signin_btn: "signin"
      }
  }.freeze

  def set_login_status_for(this_feature,status)

    # Load data from file
    CSV::Converters[:blank_to_nil] = lambda do |field|
      field && field.empty? ? nil : field
    end
    # Then we create and populate our array
    profiles = []
    CSV.foreach("file.csv", :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil]) do |row|
      profiles << Hash[row.headers.zip(row.fields)]
    end

    p ">>>> in set_login_status_for"

    profiles.each do |profile|
        if profile[:current_feature].include? this_feature
            profile[:already_logged_in] = status 

            p ">>>> SETTING already_logged_in FOR FEATURE: "
            p this_feature
            p ">>>> TO STATUS: "
            p status
              
            column_names = profiles.first.keys
            s=CSV.generate do |csv|
              csv << column_names
              profiles.each do |x|
                csv << x.values
              end
            end
            begin
            File.write('file.csv', s)
            rescue
            p ">>>>>>>>>>> COULD NOT WRITE TO FILE"
            end
            return
          end
        end
  end

  # login using a given username and password
  # @param username [String] User to log in
  # @param password [String] Password to use
  def login(username, password)
    begin
      username_field = wait_to_find_element(:id, LOCATORS[:id][:username_textbox])
      password_field = wait_to_find_element(:id, LOCATORS[:id][:password_textbox])
      signin_button = wait_to_find_element(:name, LOCATORS[:name][:signin_btn])

      send_keys(username_field, username)
      send_keys(password_field, password)
      # sleep(4)
      click_on(signin_button)
      # sleep(4)
    rescue
      return false
    end
  end

  def get_login_status_for(this_feature)
    # Load data from file
   CSV::Converters[:blank_to_nil] = lambda do |field|
     field && field.empty? ? nil : field
   end
   # Then we create and populate our array
   profiles = []
   #sleep(2)
   CSV.foreach("file.csv", :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil]) do |row|
     profiles << Hash[row.headers.zip(row.fields)]
   end
    profiles.each do |profile|
        p ">>>> get_login_status_for: each"
        if !profile[:current_feature].nil?
         if profile[:current_feature].include? this_feature
          return profile[:already_logged_in].to_i
         end
        end    
    end
    p "NO MATCH!"
    return "NO MATCH!"
 end

  def set_first_blank_feature_id_to(this_feature)
    #sleep(1)
    # Load data from file
    CSV::Converters[:blank_to_nil] = lambda do |field|
      field && field.empty? ? nil : field
    end
    # Then we create and populate our array
    profiles = []
    CSV.foreach("file.csv", :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil]) do |row|
      profiles << Hash[row.headers.zip(row.fields)]
    end
    p ">>>> in set_first_blank_feature_id_to"
    p profiles

    p "-------------------------------------"

    profiles.each do |profile|

      p "-------------------------"
      p profile[:current_feature]
      p "-------------------------"

        p ">>>> in set_first_blank_feature_id_to: each"
    
        if profile[:current_feature].nil?

          profile[:current_feature] = this_feature

          p $profiles

          
          column_names = profiles.first.keys
          s=CSV.generate do |csv|
            csv << column_names
            profiles.each do |x|
              csv << x.values
            end
          end
          begin
          File.write('file.csv', s)
          rescue
            p ">>>> SLEEPING FOR RANDOM TIME"
            sleep(rand(5))
            File.write('file.csv', s)
          end
          return
        end
    end
  end


  def check_hash_for(this_feature)

    p ">>>> in check_hash_for, looking for: "
    p this_feature

    # Load data from file
    CSV::Converters[:blank_to_nil] = lambda do |field|
      field && field.empty? ? nil : field
    end
    # Then we create and populate our array
    profiles = []
    CSV.foreach("file.csv", :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil]) do |row|
      profiles << Hash[row.headers.zip(row.fields)]
    end

    p "profiles is: "
    p profiles

    profiles.each do |profile|
      

        p ">>>> profile[:current_feature] is: "
        p profile[:current_feature]
    
        if !profile[:current_feature].nil?
          if profile[:current_feature].include? this_feature
            p "MATCH!"
            return "MATCH!"
          end
        end


    
    end

    p "NO MATCH!"
    return "NO MATCH!"

  end

  def get_username_for(this_feature)
    sleep(3)
    # Load data from file
    CSV::Converters[:blank_to_nil] = lambda do |field|
      field && field.empty? ? nil : field
    end
    # Then we create and populate our array
    profiles = []
    CSV.foreach("file.csv", :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil]) do |row|
      profiles << Hash[row.headers.zip(row.fields)]
    end

    profiles.each do |profile|
      p ">>>> CHECKING USERNAME"
      p profile[:current_feature]
        if profile[:current_feature].include? this_feature
          p ">>>> get username"
          return profile[:username]
        end
    end 
  end

  def get_password_for(this_feature)
    # Load data from file
    CSV::Converters[:blank_to_nil] = lambda do |field|
      field && field.empty? ? nil : field
    end
    # Then we create and populate our array
    profiles = []
    CSV.foreach("file.csv", :headers => true, :header_converters => :symbol, :converters => [:all, :blank_to_nil]) do |row|
      profiles << Hash[row.headers.zip(row.fields)]
    end

    profiles.each do |profile|
        
        if profile[:current_feature].include? this_feature
          p ">>>> get password"
          return profile[:password]
        end
      end
  end

end
