require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "InternetExplorer" do
  before :each do
    @browser = InternetExplorer.new
  end

  describe "Cross OS Internet Explorer", :shared => true do
    it "should not be supported" do
      @browser.should_not be_supported
    end

    it "return name" do
      @browser.name.should == "Internet Explorer"
    end
  end

  describe "Mac OS X" do
    it_should_behave_like "Cross OS Internet Explorer"
  end if macos?

  describe "Windows" do
    it "return name" do
      @browser.name.should == "Internet Explorer"
    end

    it "should be supported" do
      @browser.should be_supported
    end

    it "should setup" do
      # TODO test on windows
      # Kernel.expects(:require).with('win32ole')
      lambda { @browser.setup }.should_not raise_error
    end

    it "should visit a given url"
  end if windows?

  describe "Linux" do
    it_should_behave_like "Cross OS Internet Explorer"
  end if linux?
end
