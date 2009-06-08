class JavaScriptTestTask < ::Rake::TaskLib
  def initialize(name = :test)
    @name = name
    @tests = []
    @browsers = []

    @queue = Queue.new

    @server = WEBrick::HTTPServer.new(:Port => 4711) # TODO: make port configurable
    @server.mount_proc("/results") do |req, res|
      @queue.push(req)
      res.body = "OK"
    end
    @server.mount("/response", BasicServlet)
    @server.mount("/slow", SlowServlet)
    @server.mount("/down", DownServlet)
    @server.mount("/inspect", InspectionServlet)
    yield self if block_given?
    define
  end

  def define
    task @name do
      trap("INT") { @server.shutdown; exit }
      t = Thread.new { @server.start }

      # run all combinations of browsers and tests
      @browsers.each do |browser|
        if browser.supported?
          t0 = Time.now
          test_suite_results = TestSuiteResults.new

          browser.setup
          puts "\nStarted tests in #{browser}."

          @tests.each do |test|
            browser.visit(get_url(test))
            results = TestResults.new(@queue.pop.query, test[:url])
            print results
            test_suite_results << results
          end

          print "\nFinished in #{Time.now - t0} seconds."
          print test_suite_results
          browser.teardown
        else
          puts "\nSkipping #{browser}, not supported on this OS."
        end
      end

      @test_builder.teardown
      @server.shutdown
      t.join
    end
  end

  def get_url(test)
    params = "resultsURL=http://localhost:4711/results&t=" + ("%.6f" % Time.now.to_f)
    params << "&tests=#{test[:testcases]}" unless test[:testcases] == :all
    "http://localhost:4711#{test[:url]}?#{params}"
  end

  def mount(path, dir=nil)
    dir = Dir.pwd + path unless dir

    # don't cache anything in our tests
    @server.mount(path, NonCachingFileHandler, dir)
  end

  # test should be specified as a hash of the form
  # {:url => "url", :testcases => "testFoo,testBar"}.
  # specifying :testcases is optional
  def run(url, testcases = :all)
    @tests << { :url => url, :testcases => testcases }
  end

  def browser(browser)
    browser =
      case(browser)
        when :firefox
          Firefox.new
        when :safari
          Safari.new
        when :ie
          InternetExplorer.new
        when :konqueror
          Konqueror.new
        when :opera
          Opera.new
        else
          browser
      end

    @browsers<<browser
  end
end
