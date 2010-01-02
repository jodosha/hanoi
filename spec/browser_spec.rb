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

  describe "Cross OS Browser", :shared => true do
    it "should check if installed" do
      File.should_receive(:exist?).and_return true
      @browser.should be_installed

      File.should_receive(:exist?).and_return false
      @browser.should_not be_installed
    end

    it "should check if runnable" do
      File.should_receive(:exist?).and_return true
      @browser.should be_runnable

      File.should_receive(:exist?).and_return false
      @browser.should_not be_runnable
    end
  end

  describe "Mac Os X" do
    it_should_behave_like "Cross OS Browser"
  end if macos?

  describe "Windows" do
    it_should_behave_like "Cross OS Browser"
  end if windows?

  describe "Linux" do
    it "should check if installed" do
      Kernel.should_receive(:system).with("which browser").and_return true
      @browser.should be_installed

      Kernel.should_receive(:system).with("which browser").and_return false
      @browser.should_not be_installed
    end

    it "should check if runnable" do
      Kernel.should_receive(:system).with("which browser").and_return true
      @browser.should be_runnable

      Kernel.should_receive(:system).with("which browser").and_return false
      @browser.should_not be_runnable
    end
  end if linux?
end
