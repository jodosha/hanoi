class JavaScriptTestTask < ::Rake::TaskLib
  BROWSERS = %w( chrome safari firefox ie konqueror opera webkit ).freeze
  attr_reader :sources_directory

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
        if browser.runnable?
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
          puts "\nSkipping #{browser}, not supported on this OS or not installed."
        end
      end

      destroy_temp_directory
      @server.shutdown
      t.join
    end
  end

  def get_url(test)
    params = "resultsURL=http://localhost:4711/results&t=" + ("%.6f" % Time.now.to_f)
    params << "&tests=#{test[:testcases]}" unless test[:testcases] == :all
    "http://localhost:4711#{test[:url]}?#{params}"
  end

  def setup(sources_directory, test_cases, browsers)
    @sources_directory = sources_directory
    test_cases = setup_tests(test_cases)
    run_test_cases(test_cases)
    setup_mount_paths
    setup_browsers(browsers)
  end

  def mount(path, dir = nil)
    dir = current_directory + path unless dir

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
        when :chrome
          Chrome.new
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
        when :webkit
          Webkit.new
        else
          browser
      end

    @browsers << browser
  end

  protected
    def setup_tests(test_cases)
      create_temp_directory
      test_cases ||= Dir["#{test_directory}/**/*_test.js"] + Dir["#{test_directory}/**/*_spec.js"]
      test_cases.map do |test_case|
        test_case = TestCase.new(test_case, test_directory)
        unless test_case.exist?
          destroy_temp_directory
          raise "Test case not found: '#{test_case.path}'"
        end
        test_case.create_temp_directory
        write_template test_case
        test_case
      end
    end

    def setup_mount_paths
      mount "/",            assets_directory
      mount "/test",        temp_directory
      mount "/javascripts", sources_directory
    end

    def setup_browsers(browsers)
      BROWSERS.each do |browser|
        browser(browser.to_sym) unless browsers && !browsers.include?(browser)
      end
    end

    def run_test_cases(test_cases)
      test_cases.each { |test_case| run test_case.url }
    end

    def test_directory
      @test_directory ||= begin
        directory = File.directory?(File.expand_path(current_directory + "/test")) ? "test" : "spec"
        directory << "/javascript"
        unless File.directory?(directory)
raise <<-END
Can't find JavaScript test directory in '#{current_directory}'.
Please make sure at least one of them exist:
\t'#{current_directory}/test/javascript'
\t'#{current_directory}/spec/javascript'\n
END
        end
        directory
      end
    end

    def template
      @template ||= begin
        path = File.expand_path(test_directory + "/templates/test_case.erb")
        raise "Can't find the Javascript test template: '#{path}'" unless File.exist?(path)
        ERB.new(File.new(path).read)
      end
    end

    def write_template(test_case)
      # instance var is needed by ERb binding.
      @test_case = test_case
      template_path = "#{test_case.temp_directory}/#{test_case.name}.html"
      File.open(template_path, 'w') { |f| f.write(template.result(binding)) }
    end

    def current_directory
      @current_directory ||= Dir.pwd
    end

    def create_temp_directory
      FileUtils.mkdir_p temp_directory
    end

    def destroy_temp_directory
      FileUtils.rm_rf(temp_directory) rescue nil
    end

    def temp_directory
      @temp_directory ||= test_directory + "/tmp"
    end

    def assets_directory
      @assets_directory ||= begin
        path = File.expand_path(current_directory + "/test/javascript/assets")
        return path if File.directory?(path)
        path = File.expand_path(current_directory + "/spec/javascript/assets")
        return path if File.directory?(path)
        raise "Cannot find:\n\t#{File.expand_path(current_directory + "/test/javascript/assets")} or\n\t#{File.expand_path(current_directory + "/spec/javascript/assets")}"
      end
    end
end
