require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "Firefox" do
  before(:each) do
    @browser = Firefox.new
  end

  it "should have a path" do
    @browser.path.should == File.join(ENV['ProgramFiles'] || 'c:\Program Files', '\Mozilla Firefox\firefox.exe')
  end

  # TODO cleanup
  it "should visit a given url" do
    url = "http://localhost"
    command = "open -a Firefox '#{url}'" if @browser.macos?
    command = "#{@path} #{url}"          if @browser.windows?
    command = "firefox #{url}"           if @browser.linux?

    Kernel.expects(:system).with(command)
    @browser.visit(url)
  end
end