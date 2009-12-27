require File.join(File.dirname(__FILE__), "spec_helper")

describe "Browser" do
  before(:each) do
    @browser = Browser.new
  end

  it "should be supported by default" do
    @browser.should be_supported
  end

  it "should recognize the current platform" do
    method = case @browser.host
    when /darwin/
      :macos?
    when /mswin/, /mingw/
      :windows?
    when /linux/
      :linux?
    end

    @browser.send(method).should be_true
  end
end
