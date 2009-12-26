require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "Safari" do
  before :each do
    @browser = Safari.new
  end

  describe "Cross OS Safari", :shared => true do
    it "should be supported" do
      @browser.should be_supported
    end

    it "return name" do
      @browser.name.should == "Safari"
    end

    it "should be kind of Webkit" do
      @browser.should be_kind_of(Webkit)
    end
  end

  describe "Mac OS X" do
    it_should_behave_like "Cross OS Safari"
  end if macos?

  describe "Windows" do
    it_should_behave_like "Cross OS Safari"
  end if windows?

  describe "Linux" do
    it "return name" do
      @browser.name.should == "safari"
    end

    it "should not be supported" do
      @browser.should_not be_supported
    end
  end if linux?
end
