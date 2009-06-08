require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "Safari" do
  before(:each) do
    @browser = Safari.new
  end

  it "should be supported on Windows and MacOS" do
    supported = !!(@browser.macos? || @browser.windows?)
    @browser.supported?.should == supported
  end

  it "should setup" do
    @browser.expects(:applescript).with('tell application "Safari" to make new document')
    @browser.setup
  end

  it "should visit a given url" do
    url = "http://localhost"
    @browser.expects(:applescript).with('tell application "Safari" to set URL of front document to "' + url + '"')
    @browser.visit(url)
  end
end