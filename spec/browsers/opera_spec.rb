require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "Opera" do
  before :each do
    @browser = Opera.new
    @url     = "http://localhost"
  end

  describe "Cross OS Opera", :shared => true do
    it "should be supported" do
      @browser.should be_supported
    end
  end

  describe "Mac OS X" do
    it_should_behave_like "Cross OS Opera"

    it "return name" do
      @browser.name.should == "Opera"
    end

    it "should have a path" do
      expected = File.expand_path("/Applications/#{@browser.escaped_name}.app")
      @browser.path.should == expected
    end

    it "should visit a given url" do
      @browser.expects(:applescript).with(%(tell application "#{@browser.name}" to GetURL "#{@url}"))
      @browser.visit(@url)
    end
  end if macos?

  describe "Windows" do
    it_should_behave_like "Cross OS Opera"

    it "return name" do
      @browser.name.should == "Opera"
    end

    it "should have a path" do
      @browser.path.should == 'c:\Program Files\Opera\Opera.exe'
    end

    it "should visit a given url" do
      Kernel.expects(:system).with("#{@browser.path} #{@url}")
      @browser.visit(@url)
    end
  end if windows?

  describe "Linux" do
    it_should_behave_like "Cross OS Opera"

    it "return name" do
      @browser.name.should == "opera"
    end

    it "should have a path" do
      path = "/usr/bin/#{@browser.name}"
      Opera.new(path).path.should == path
    end

    it "should visit a given url" do
      Kernel.expects(:system).with("#{@browser.name} #{@url}")
      @browser.visit(@url)
    end
  end if linux?
end
