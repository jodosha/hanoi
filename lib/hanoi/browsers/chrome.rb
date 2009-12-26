class Chrome < Browser
  def initialize(path = nil)
    @path = path || File.join(
      ENV['UserPath'] || ENV['UserProfile'] || "C:/Documents and Settings/Administrator",
      "Local Settings",
      "Application Data",
      "Google",
      "Chrome",
      "Application",
      "chrome.exe"
    )
  end

  def supported?
    windows? || macos?
  end

  def name
    "Google Chrome"
  end
end
