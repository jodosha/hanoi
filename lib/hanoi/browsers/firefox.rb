class Firefox < Browser
  def initialize(path = File.join(ENV['ProgramFiles'] || 'c:\Program Files', '\Mozilla Firefox\firefox.exe'))
    @path = path
  end

  def teardown
    if macos?
      system("killall firefox-bin")
    end
  end
end
