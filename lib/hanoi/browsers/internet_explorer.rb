class InternetExplorer < Browser
  def initialize(path = nil)
    @path = path || File.join(
      ENV['UserPath'] || ENV['UserProfile'] || "C:/Documents and Settings/Administrator",
      "Internet Explorer",
      "iexplore.exe"
    )
  end

  def setup
    require 'win32ole' if windows?
  end

  def supported?
    windows?
  end
  
  def visit(url)
    if windows?
      ie = WIN32OLE.new('InternetExplorer.Application')
      ie.visible = true
      ie.Navigate(url)
      sleep 0.01 while ie.Busy || ie.ReadyState != 4
    end
  end

  def name
    "Internet Explorer"
  end
end
