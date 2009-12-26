class Safari < Webkit
  def initialize(path = File.join(ENV['ProgramFiles'] || 'c:\Program Files', '\Safari\Safari.exe'))
    @path = path
  end
end
