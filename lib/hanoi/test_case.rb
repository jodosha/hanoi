class TestCase
  attr_reader :path

  def initialize(path)
    @path = path
  end
  
  def name
    @name ||= File.basename(@path, '.js')
  end

  def target
    "/javascripts/#{name.gsub('_test', '')}.js"
  end

  def content
    File.new(@path).read
  end

  def exist?
    File.exist?(path)
  end

  def url
    "/test/#{name}.html"
  end

  # TODO enable
  # def html_fixtures
  #   path = "#{@plugin.root}/test/javascript/fixtures/#{type}/#{relative_path.gsub("_test.js", "_fixtures.html")}"
  #   File.new(path).read rescue ""
  # end
end