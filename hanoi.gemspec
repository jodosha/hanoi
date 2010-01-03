Gem::Specification.new do |s|
  s.name               = "hanoi"
  s.version            = "0.0.3"
  s.date               = "2010-01-03"
  s.summary            = "Automated jQuery tests with QUnit"
  s.author             = "Luca Guidi"
  s.email              = "guidi.luca@gmail.com"
  s.description        = "Automated jQuery tests with QUnit"
  s.has_rdoc           = true
  s.executables        = [ 'hanoi' ]
  s.files              = ["MIT-LICENSE", "README.md", "Rakefile", "bin/hanoi", "hanoi.gemspec", "lib/hanoi.rb", "lib/hanoi/browser.rb", "lib/hanoi/browsers/chrome.rb", "lib/hanoi/browsers/firefox.rb", "lib/hanoi/browsers/internet_explorer.rb", "lib/hanoi/browsers/konqueror.rb", "lib/hanoi/browsers/opera.rb", "lib/hanoi/browsers/safari.rb", "lib/hanoi/browsers/webkit.rb", "lib/hanoi/javascript_test_task.rb", "lib/hanoi/test_case.rb", "lib/hanoi/test_results.rb", "lib/hanoi/test_suite_results.rb", "lib/hanoi/webrick.rb", "spec/browser_spec.rb", "spec/browsers/chrome_spec.rb", "spec/browsers/firefox_spec.rb", "spec/browsers/internet_explorer_spec.rb", "spec/browsers/konqueror_spec.rb", "spec/browsers/opera_spec.rb", "spec/browsers/safari_spec.rb", "spec/browsers/webkit_spec.rb", "spec/spec_helper.rb", "templates/assets/jquery.js", "templates/assets/testrunner.js", "templates/assets/testsuite.css", "templates/example_fixtures.html", "templates/example_test.js", "templates/fresh_rakefile", "templates/test_case.erb"]
  s.test_files         = ["spec/browser_spec.rb", "spec/browsers/chrome_spec.rb", "spec/browsers/firefox_spec.rb", "spec/browsers/internet_explorer_spec.rb", "spec/browsers/konqueror_spec.rb", "spec/browsers/opera_spec.rb", "spec/browsers/safari_spec.rb", "spec/browsers/webkit_spec.rb"]
  s.extra_rdoc_files   = ["README.md"]
end
