# Basic model for the login screen
class StoryDetails < BaseScreen
    # Locators for elements available on the Login Screen
    LOCATORS = {
  
        xpath: {
            #sliders
            lead_image_slider: "//div[@data-tracking='Story_Edit_Lead_Image']/div/div/label/div[@class='btn-toggle-handle animate-fast']",
            push_to_top_slider: "//*[contains(text(),'Push to top')]/following-sibling::*/label[contains(@class,'btn-toggle')]",
            #place to hover and restore layout glitch evident in automation only
            place_to_hover: "//*[@class='story-items-toolbar ember-view']",

            #toolbar items '+' button, only visible when hovering over it, use place_to_hover first. There >should< only be 1 visible at a time
            visible_toolbar_expander: "//*[contains(@class,'btn-story-item-toolbar-add')]",

            #dropdowns
            #story layout
            story_layout: "//*[@id='story-layout-select']",
            standard_story_layout: "//h2[contains(.,'Story Template')]/../following-sibling::div/div/div/div/select/option[contains(.,'standard')]",
            long_form_story_layout: "//h2[contains(.,'Story Template')]/../following-sibling::div/div/div/div/select/option[contains(.,'standard')]",
            #editorial agenda
            editorial_agenda: "//select[@id='story-agenda-item-select']",
            editorial_agenda_list: "//select[@id='story-agenda-item-select']/option",
            #clearance
            clearance: "//div[@id='story-clearance']/div[@class='story-mod-row']/div/select",
            clearance_list: "//div[@id='story-clearance']/div[@class='story-mod-row']/div/select/option",
            #guidance
            guidance: "//div[@id='story-guidance']/div[@class='story-mod-row']/div/select",
            guidance_list: "//div[@id='story-guidance']/div[@class='story-mod-row']/div/select/option",
            #redistribution
            redistribution: "//div[@id='story-redistribution']/div[@class='story-mod-row']/div/select",
            redistribution_list: "//div[@id='story-redistribution']/div[@class='story-mod-row']/div/select/option",

            #dropdowns
            #source
            source: "//*[@id='story-mod-source']/div/div/div/div/select",
            source_list: "//*[@id='story-mod-source']/div/div/div/div/select/option",
            #location
            location: "//*[@id='story-mod-location']/div/div/div/div/select",
            location_list: "//*[@id='story-mod-location']/div/div/div/div/select/option",
            #date
            date: "//*[@id='story-mod-date']/div/div/div/div/select",
            date_list: "//*[@id='story-mod-date']/div/div/div/div/select/option",

            #tabs
            clearance_tab: "//li[contains(text(),'Clearance')]",
            guidance_tab: "//li[contains(text(),'Guidance')]",
            redistribution_tab: "//li[contains(text(),'Redistribution')]",

            #text_field
            stated_source: "//*[@placeholder='Stated Source']",
            stated_location: "//*[@placeholder='Stated Location']",
            lat_lng: "//*[@placeholder='Lat, Lng']",
            zoom_level: "//*[@placeholder='Zoom Level']",
            stated_date: "//*[@placeholder='Stated Date']",
            select_a_curator: "//*[@placeholder='Select a curator']",
            enter_your_editorial_content_here: "//*[@placeholder='Enter your editorial content here']",
            add_a_keyword: "//*[@placeholder='Add a keyword']",
            add_a_collection: "//*[@placeholder='Add a collection']",
            add_a_company: "//*[@placeholder='Add a company']",


            #select a curator type ahead suggestions
            type_ahead_suggestions: "//*[@class='typeahead-suggestion']",

            #list of orderable items
            orderable_items: "//*[contains(@class,'control-drag fa fa-arrows')]",

            #buttons
            #add story item
            add_story_item: "//*[@class='btn btn-story-item-toolbar btn-sm']",

            #expanders
            expanders: "//*[contains(@class,'control-toggle')]",

        },
        name: {

        }
    }.freeze

    def select_meta_category(category)
        meta_category = wait_to_find_element(:xpath, "//div[@data-tracking='Story_Edit_Meta_Categories']/div/div/span/span/span[text()='#{category}']")
        click_on(meta_category)
    end

    def select_meta_channel(channel)
        meta_channel = wait_to_find_element(:xpath, "//div[@data-tracking='Story_Edit_Meta_Channels']/div/div/span/span[text()='#{channel}']")
        click_on(meta_channel)
    end

    def expand_section(section)
        expanders = wait_to_find_elements(:xpath, LOCATORS[:xpath][:expanders])
        idx = section.to_i - 1
        click_on(expanders[idx])
    end

    def check_text(text_area,text_to_check)
        text_areas_to_check = wait_to_find_elements(:xpath, "//*[contains(@class,'ember-text-area')]")

        el = nil
        #get the open one...
        text_areas_to_check.each do |a|
            if a.attribute("scrollHeight").to_i == 88
                el = a
                break
            end
        end
        
        if !el.attribute("value").include? text_to_check
            return false
        else
            return nil
        end
    end

    def click_add_story_item
        add_story_item = wait_to_find_element(:xpath, LOCATORS[:xpath][:add_story_item])
        click_on(add_story_item)
    end

    def select_story_items_toolbar(row)
        sleep(1)
        #toolbars = wait_to_find_element(:xpath, LOCATORS[:xpath][:place_to_hover])
        p "p toolbars.size is: "
        p toolbars
        idx = row.to_i - 1
        #hover(toolbars)
        sleep(1)
        visible_toolbars = wait_to_find_element(:xpath, LOCATORS[:xpath][:visible_toolbar_expander])
        click_on(visible_toolbars)
    end

    def click_toolbar_button(name)
        button_to_click =  wait_to_find_element(:xpath, "//*[@class='btn-label'][contains(text(),'#{name}')]")
        click_on(button_to_click)
    end

    def reorder_items(from_pos,to_pos)

        #sleep(3)

        frm_item = from_pos.to_i
        to_item = to_pos.to_i

        frm_item-=1
        to_item-=1

        retries = 0

        begin


            items = wait_to_find_elements(:xpath, LOCATORS[:xpath][:orderable_items])

            $driver.action.click_and_hold(items[frm_item]).perform
            $driver.action.drag_and_drop(items[frm_item], items[to_item]).perform
            $driver.action.release.perform
        rescue
            p 'Retrying...'
            retry if (retries += 1) < 3
        end

        #sleep(3)
        #return nil
    end

    def update_slider(slider,status)
        #place_to_hover = wait_to_find_element(:xpath, LOCATORS[:xpath][:place_to_hover])
        case slider
            when 'LEAD IMAGE'
                slider_button = wait_to_find_element(:xpath, LOCATORS[:xpath][:lead_image_slider])
            when 'PUSH TO TOP'
                slider_button = wait_to_find_element(:xpath, LOCATORS[:xpath][:push_to_top_slider])
        end
        if slider_button.nil?
            return false
        end

        #hover(slider_button)
        click_on(slider_button)
        sleep(1)
        #hover(place_to_hover)

        return nil        
    end

    def update_dropdown(dropdown,value)
        #place_to_hover = wait_to_find_element(:xpath, LOCATORS[:xpath][:place_to_hover])
        case dropdown
        when 'STORY TEMPLATE'
            selected_dropdown = wait_to_find_element(:xpath, LOCATORS[:xpath][:story_layout])
            p selected_dropdown
            case value
            when 'STANDARD'
                updated_val = 'standard'
            when 'LONG FORM'
                updated_val = 'longform'
            end
        when 'EDITORIAL AGENDA'
            selected_dropdown = wait_to_find_element(:xpath, LOCATORS[:xpath][:editorial_agenda])
            items = wait_to_find_elements(:xpath, LOCATORS[:xpath][:editorial_agenda_list])
        #tabs on right
        when 'Clearance'
            selected_dropdown = wait_to_find_element(:xpath, LOCATORS[:xpath][:clearance])
            items = wait_to_find_elements(:xpath, LOCATORS[:xpath][:clearance_list])
        when 'Guidance'
            selected_dropdown = wait_to_find_element(:xpath, LOCATORS[:xpath][:guidance])
            items = wait_to_find_elements(:xpath, LOCATORS[:xpath][:guidance_list])
        when 'Redistribution'
            selected_dropdown = wait_to_find_element(:xpath, LOCATORS[:xpath][:redistribution])
            items = wait_to_find_elements(:xpath, LOCATORS[:xpath][:redistribution_list])
        #source
        when 'SOURCE'
            selected_dropdown = wait_to_find_element(:xpath, LOCATORS[:xpath][:source])
            items = wait_to_find_elements(:xpath, LOCATORS[:xpath][:source_list])
        #location
        when 'LOCATION'
        selected_dropdown = wait_to_find_element(:xpath, LOCATORS[:xpath][:location])
        items = wait_to_find_elements(:xpath, LOCATORS[:xpath][:location_list])
        #date
        when 'DATE'
        selected_dropdown = wait_to_find_element(:xpath, LOCATORS[:xpath][:date])
        items = wait_to_find_elements(:xpath, LOCATORS[:xpath][:date_list])
        end

        index = 0

        if !items.nil?
            items.each_with_index do |a,i|
                p a.attribute("value")
                p a.text
                if a.text.include? value
                    index = i
                    break
                end
            end
        end

        p "selected_dropdown.size is: "
        p selected_dropdown.size
        #hover(selected_dropdown)
        $driver.execute_script("arguments[0].selectedIndex=#{index};",selected_dropdown)
        #hover(place_to_hover)

    end

    def click_tab(tab_name)
        #place_to_hover = wait_to_find_element(:xpath, LOCATORS[:xpath][:place_to_hover])
        case tab_name
        when 'Clearance'
            selected_tab = wait_to_find_element(:xpath, LOCATORS[:xpath][:clearance_tab])
        when 'Guidance'
            selected_tab = wait_to_find_element(:xpath, LOCATORS[:xpath][:guidance_tab])
        when 'Redistribution'
            selected_tab = wait_to_find_element(:xpath, LOCATORS[:xpath][:redistribution_tab])
        end

        #hover(selected_tab)
        click_on(selected_tab)
        #sleep(1)
        #hover(place_to_hover)
    end

    def enter_text_and_choose(text_field,value)
        enter_text(text_field,value)
        sleep(3)
        results_list = wait_to_find_elements(:xpath, "//*[contains(@class,'form-tags-search-option')]")
        results_list.each do |a|
            if a.text == value
                return click_on(a)
            end
        end
        return false
    end

    def enter_text(text_field,value)
        #place_to_hover = wait_to_find_element(:xpath, LOCATORS[:xpath][:place_to_hover])
        case text_field
        when 'Stated Source'
            field_to_update = wait_to_find_element(:xpath, LOCATORS[:xpath][:stated_source])
        when 'Stated Location'
            field_to_update = wait_to_find_element(:xpath, LOCATORS[:xpath][:stated_location])
        when 'Lat, Lng'
            field_to_update = wait_to_find_element(:xpath, LOCATORS[:xpath][:lat_lng])
        when 'Zoom Level'
            field_to_update = wait_to_find_element(:xpath, LOCATORS[:xpath][:zoom_level])
        when 'Stated Date'
            field_to_update = wait_to_find_element(:xpath, LOCATORS[:xpath][:stated_date])
        when 'Select a curator'
            field_to_update = wait_to_find_element(:xpath, LOCATORS[:xpath][:select_a_curator])
        when 'Enter your editorial content here'
            field_to_update = wait_to_find_element(:xpath, LOCATORS[:xpath][:enter_your_editorial_content_here])
        when 'Add a keyword'
            field_to_update = wait_to_find_element(:xpath, LOCATORS[:xpath][:add_a_keyword])
        when 'Add a collection'
            field_to_update = wait_to_find_element(:xpath, LOCATORS[:xpath][:add_a_collection])
        when 'Add a company'
            field_to_update = wait_to_find_element(:xpath, LOCATORS[:xpath][:add_a_company])
        end

        $driver.action.key_down(field_to_update, :command).send_keys("a").key_up(:command).perform
        text_length = field_to_update.attribute("selectionEnd").to_i

        for i in 1..text_length-1 do
            $driver.action.send_keys(field_to_update, :backspace).perform
            i+=1
        end

        field_to_update.send_keys(value)

        if text_field == 'Stated Date'
            click_on(place_to_hover)
        end

        if text_field == 'Select a curator'
            suggestions = wait_to_find_elements(:xpath, LOCATORS[:xpath][:type_ahead_suggestions])
            click_on(suggestions[0])
        end

        #sleep(1)
        #hover(place_to_hover)
    end

end
