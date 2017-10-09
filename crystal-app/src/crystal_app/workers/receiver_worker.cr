require "sidekiq"

module CrystalApp::Workers
  class ReceiverWorker
    FILE_PATH = "../tmp/output.txt"

    include Sidekiq::Worker

    sidekiq_options do |job|
      job.queue = "crystal"
    end

    def perform(@time : Int32)
      append_to_file

      sleep(@time.as(Number))
      job = Sidekiq::Job.new
      job.klass = "RubyApp::Workers::ProducerWorker"
      job.queue = "ruby"
      client = Sidekiq::Client.new
      jid = client.push(job)
    end

    private def append_to_file
      file = File.new(FILE_PATH, "a")
      file.puts("#{@time} seconds sleep received")
      file.flush
      file.close
    end
  end
end
