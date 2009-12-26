require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "Konqueror" do
  before :each do
    @browser = Konqueror.new
  end

  describe "Cross OS Konqueror", :shared => true do
    it "return name" do
      @browser.name.should == "Konqueror"
    end

    it "should not be supported" do
      @browser.should_not be_supported
    end
  end

  describe "Mac OS X" do
    it_should_behave_like "Cross OS Konqueror"
  end if macos?

  describe "Windows" do
    it_should_behave_like "Cross OS Konqueror"
  end if windows?

  describe "Linux" do
    it "return name" do
      @browser.name.should == "konqueror"
    end

    it "should be supported" do
      @browser.should be_supported
    end

    it "should visit a given url" do
      url = "http://localhost"
      Kernel.expects(:system).with("kfmclient openURL #{url}")
      @browser.visit(url)
    end
  end if linux?
end