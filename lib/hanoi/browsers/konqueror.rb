class Konqueror < Browser
  @@config_dir = File.join((ENV['HOME'] || ''), '.kde', 'share', 'config')
  @@global_config = File.join(@@config_dir, 'kdeglobals')
  @@konqueror_config = File.join(@@config_dir, 'konquerorrc')

  def supported?
    linux?
  end

  # Forces KDE's default browser to be Konqueror during the tests, and forces
  # Konqueror to open external URL requests in new tabs instead of a new
  # window.
  def setup
    cd @@config_dir, :verbose => false do
      copy @@global_config, "#{@@global_config}.bak", :preserve => true, :verbose => false
      copy @@konqueror_config, "#{@@konqueror_config}.bak", :preserve => true, :verbose => false
      # Too lazy to write it in Ruby...  Is sed dependency so bad?
      system "sed -ri /^BrowserApplication=/d  '#{@@global_config}'"
      system "sed -ri /^KonquerorTabforExternalURL=/s:false:true: '#{@@konqueror_config}'"
    end
  end

  def teardown
    cd @@config_dir, :verbose => false do
      copy "#{@@global_config}.bak", @@global_config, :preserve => true, :verbose => false
      copy "#{@@konqueror_config}.bak", @@konqueror_config, :preserve => true, :verbose => false
    end
  end

  def visit(url)
    system("kfmclient openURL #{url}")
  end

  def to_s
    "Konqueror"
  end
end
