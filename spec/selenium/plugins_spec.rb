require File.expand_path(File.dirname(__FILE__) + '/common')

describe "plugins ui" do
  it_should_behave_like "in-process server selenium tests"

  it 'should have plugins default to disabled when no plugin_setting exits' do
    site_admin_logged_in
    truncate_table PluginSetting

    get '/plugins/etherpad'
    driver.execute_script("return $('#plugin_setting_disabled').is(':checked');").should be_true
    expect_new_page_load { driver.find_element(:css, "button.save_button").click }
    PluginSetting.all.count.should == 1
    PluginSetting.first.tap do |ps|
      ps.name.should == "etherpad"
      ps.disabled.should be_true
    end
    get '/plugins/etherpad'
    driver.execute_script("return $('#plugin_setting_disabled').is(':checked');").should be_true

    truncate_table PluginSetting
    get '/plugins/etherpad'
    driver.execute_script("return $('#plugin_setting_disabled').is(':checked');").should be_true
    driver.find_element(:css, '#plugin_setting_disabled').click
    expect_new_page_load { driver.find_element(:css, "button.save_button").click }
    PluginSetting.all.count.should == 1
    PluginSetting.first.tap do |ps|
      ps.name.should == "etherpad"
      ps.disabled.should be_false
    end
    get '/plugins/etherpad'
    driver.execute_script("return $('#plugin_setting_disabled').is(':checked');").should be_false
  end
end
