require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "InternetExplorer" do
  before(:each) do
    @browser = InternetExplorer.new
  end

  it "should be supported on Windows" do
    supported = !!(@browser.windows?)
    @browser.supported?.should == supported
  end

  it "should setup" do
    if @browser.windows?
      # TODO test on windows
      # Kernel.expects(:require).with('win32ole')
      lambda { @browser.setup }.should_not raise_error
    end
  end

  it "should visit a given url"
end