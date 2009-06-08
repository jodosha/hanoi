require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "Konqueror" do
  before(:each) do
    @browser = Konqueror.new
  end

  it "should be supported on Linux" do
    supported = !!@browser.linux?
    @browser.supported?.should == supported
  end

  it "should visit a given url" do
    url = "http://localhost"
    Kernel.expects(:system).with("kfmclient openURL #{url}")
    @browser.visit(url)
  end
end