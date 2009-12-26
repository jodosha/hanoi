$: << File.join(File.dirname(__FILE__), "/../lib")
require "rubygems"
require "mocha"
require "hanoi"

module Kernel
  alias_method :old_system, :system
  def system(*args)
  end
end

# TODO delegation
def macos?
  Browser.new.macos?
end

def windows?
  Browser.new.windows?
end

def linux?
  Browser.new.linux?
end
