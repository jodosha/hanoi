require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "Chrome" do
  before(:each) do
    @browser = Chrome.new
    @url     = "http://localhost"
  end

  describe "Cross OS Chrome", :shared => true do
    it "should be supported" do
      @browser.should be_supported
    end

    it "return name" do
      @browser.name.should == "Google Chrome"
    end
  end

  describe "Mac OS X" do
    it_should_behave_like "Cross OS Chrome"

    it "should have a path" do
      expected = File.expand_path("/Applications/#{@browser.escaped_name}.app")
      @browser.path.should == expected
    end

    it "should visit a given url" do
      Kernel.expects(:system).with("open -a #{@browser.name} '#{@url}'")
      @browser.visit(@url)
    end
  end if macos?

  describe "Windows" do
    it_should_behave_like "Cross OS Chrome"

    it "should have a path" do
      expected = File.join(
        ENV['UserPath'] || ENV['UserProfile'] || "C:/Documents and Settings/Administrator",
        "AppData",
        "Local",
        "Google",
        "Chrome",
        "Application",
        "chrome.exe"
      )

      @browser.path.should == expected
    end

    it "should visit a given url" do
      Kernel.expects(:system).with("#{@browser.path} #{@url}")
      @browser.visit(@url)
    end
  end if windows?

  describe "Linux" do
    it "return name" do
      @browser.name.should == "Google Chrome"
    end

    it "should not be supported" do
      @browser.should_not be_supported
    end
  end if linux?
end
