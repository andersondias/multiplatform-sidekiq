module RubyApp
  require_relative 'ruby_app/workers'

  def self.start
    RubyApp::Workers::ProducerWorker.perform_async
  end
end

RubyApp.start
