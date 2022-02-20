class EventGreetingWorker
  include Sidekiq::Worker

  def perform(*args)
      date = Date.today
      @event = Event.where(:start_time => Date.today)
      @event.each do |e|
        p "#{e.event_name}"
        EventMailer.send_request(e)
      end
      # @event = Event.find_start_time(beg)
  end
end
