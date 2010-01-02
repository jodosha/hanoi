class Browser
  def supported?; true; end
  def setup; end
  def teardown; end

  def host
    require 'rbconfig'
    Config::CONFIG['host']
  end

  def macos?
    host.include?('darwin')
  end

  def windows?
    /mswin|mingw/.match host
  end

  def linux?
    host.include?('linux')
  end

  def installed?
    if linux?
      Kernel.system "which #{name}"
    else
      File.exist? path
    end
  end

  def runnable?
    supported? && installed?
  end

  def visit(url)
    if macos?
      system("open -g -a #{path} '#{url}'")
    elsif windows?
      system("#{path} #{url}")
    elsif linux?
      system("#{name} #{url}")
    end
  end

  def name
    n = self.class.name.split('::').last
    linux? ? n.downcase : n
  end

  def escaped_name
    name.gsub(' ', '\ ')
  end

  def path
    if macos?
      File.expand_path("/Applications/#{escaped_name}.app")
    else
      @path
    end
  end

  def to_s
    name
  end  
end
