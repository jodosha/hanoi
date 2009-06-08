$: << File.join(File.dirname(__FILE__), "/../lib")
require "rubygems"
require "mocha"
require "hanoi"

module Kernel
  alias_method :old_system, :system
  def system(*args)
  end
end

class Browser; attr_reader :path end
