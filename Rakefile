# frozen_string_literal: true

require('rake/testtask')

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/test_*.rb']
end
desc('Run tests')

task(default: :test)
