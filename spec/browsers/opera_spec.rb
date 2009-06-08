require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "Opera" do
  before(:each) do
    @browser = Opera.new
  end

  it "should have a path" do
    @browser.path.should == 'c:\Program Files\Opera\Opera.exe'
  end

  it "should visit a given url" do
    url = "http://localhost"

    if @browser.macos?
      @browser.expects(:applescript).with('tell application "Opera" to GetURL "' + url + '"')
    elsif @browser.windows?
      Kernel.expects(:system).with("#{@browser.path} #{url}")
    else
      Kernel.expects(:system).with("opera #{url}")
    end

    @browser.visit(url)
  end
end