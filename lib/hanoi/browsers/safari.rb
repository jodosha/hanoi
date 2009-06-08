class Safari < Browser
  def supported?
    macos? || windows?
  end

  def setup
    applescript('tell application "Safari" to make new document')
  end

  def visit(url)
    applescript('tell application "Safari" to set URL of front document to "' + url + '"')
  end

  def teardown
    #applescript('tell application "Safari" to close front document')
  end

  def to_s
    "Safari"
  end
end
