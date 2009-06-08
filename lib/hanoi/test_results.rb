class TestResults
  attr_reader :modules, :tests, :assertions, :failures, :errors, :filename
  def initialize(query, filename)
    @modules    = query['modules'].to_i
    @tests      = query['tests'].to_i
    @assertions = query['assertions'].to_i
    @failures   = query['failures'].to_i
    @errors     = query['errors'].to_i
    @filename   = filename
  end
  
  def error?
    @errors > 0
  end
  
  def failure?
    @failures > 0
  end
  
  def to_s
    return "E" if error?
    return "F" if failure?
    "."
  end
end
