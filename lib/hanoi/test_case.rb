class TestCase
  attr_reader :path

  def initialize(path, test_directory)
    @path, @test_directory = path, test_directory
  end

  def name
    @name ||= File.basename(@path, '.js')
  end

  def target
    "/javascripts/#{relative_path.gsub('_test', '')}"
  end

  def content
    File.new(@path).read
  end

  def exist?
    File.exist?(path)
  end

  def relative_path
    @relative_path ||= @path.gsub("#{@test_directory}/", "")
  end

  def url
    "/test/#{relative_path.gsub('.js', '')}.html"
  end

  def create_temp_directory
    FileUtils.mkdir_p temp_directory
  end

  def temp_directory
    @temp_directory ||= File.dirname(File.expand_path(@path).gsub(@test_directory, "#{@test_directory}/tmp"))
  end

  def html_fixtures
    path = File.dirname(File.expand_path(@path).gsub(@test_directory, "#{@test_directory}/fixtures"))
    path = File.expand_path(path + "/#{name.gsub('_test', '_fixtures.html')}")
    File.new(path).read rescue ""
  end
end