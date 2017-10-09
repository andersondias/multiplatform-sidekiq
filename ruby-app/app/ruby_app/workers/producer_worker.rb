require "sidekiq"

class RubyApp::Workers::ProducerWorker
  include Sidekiq::Worker

  sidekiq_options queue: "ruby"

  def perform
    Sidekiq::Client.push(
      'class' => 'CrystalApp::Workers::ReceiverWorker',
      'args' => [rand(10)],
      'queue' => 'crystal'
    )
  end
end
