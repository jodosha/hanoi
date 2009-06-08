class Firefox < Browser
  def initialize(path = File.join(ENV['ProgramFiles'] || 'c:\Program Files', '\Mozilla Firefox\firefox.exe'))
    @path = path
  end

  def visit(url)
    system("open -a Firefox '#{url}'") if macos?
    system("#{@path} #{url}") if windows?
    system("firefox #{url}") if linux?
  end

  def to_s
    "Firefox"
  end
end
