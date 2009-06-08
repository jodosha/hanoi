class Opera < Browser
  def initialize(path = 'c:\Program Files\Opera\Opera.exe')
    @path = path
  end
  
  def setup
    if windows?
      puts %{
        MAJOR ANNOYANCE on Windows.
        You have to shut down Opera manually after each test
        for the script to proceed.
        Any suggestions on fixing this is GREATLY appreciated!
        Thank you for your understanding.
      }
    end
  end
  
  def visit(url)
    applescript('tell application "Opera" to GetURL "' + url + '"') if macos?
    system("#{@path} #{url}") if windows? 
    system("opera #{url}")  if linux?
  end

  def to_s
    "Opera"
  end
end
