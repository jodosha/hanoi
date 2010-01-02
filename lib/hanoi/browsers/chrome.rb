class Chrome < Browser
  def initialize(path = nil)
    @path = path || File.join(
      ENV['UserPath'] || ENV['UserProfile'] || "C:/Documents and Settings/Administrator",
      "AppData",
      "Local",
      "Google",
      "Chrome",
      "Application",
      "chrome.exe"
    )
  end

  def supported?
    windows? || macos?
  end

  def installed?
    if macos?
      File.exist?("/Applications/#{name}.app")
    else
      super
    end
  end

  def name
    "Google Chrome"
  end
end
