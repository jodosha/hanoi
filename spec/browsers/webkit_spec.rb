require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "Webkit" do
  before :each do
    @browser = Webkit.new
  end

  describe "Cross OS Webkit", :shared => true do
    it "should be supported" do
      @browser.should be_supported
    end
  end

  describe "Mac OS X" do
    it_should_behave_like "Cross OS Webkit"

    it "return name" do
      @browser.name.should == "Webkit"
    end

    it "should setup" do
      @browser.expects(:applescript).with(%(tell application "#{@browser.name}" to make new document))
      @browser.setup
    end

    it "should visit a given url" do
      url = "http://localhost"
      @browser.expects(:applescript).with(%(tell application "#{@browser.name}" to set URL of front document to "#{url}"))
      @browser.visit(url)
    end
  end if macos?

  describe "Windows" do
    it_should_behave_like "Cross OS Webkit"

    it "return name" do
      @browser.name.should == "Webkit"
    end

    it "should setup" do
      @browser.should_not_receive(:applescript)
      @browser.setup
    end

    it "should visit a given url" do
      Kernel.expects(:system).with("#{@browser.path} #{@url}")
      @browser.visit(@url)
    end
  end if windows?

  describe "Linux" do
    it "return name" do
      @browser.name.should == "webkit"
    end

    it "should not be supported" do
      @browser.should_not be_supported
    end
  end if linux?
end
