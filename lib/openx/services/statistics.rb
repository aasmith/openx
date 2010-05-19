module OpenX
  module Services
    module Statistics
      
      # Generic method to get statistics.
      # - +service_method+ - The name of the OpenX API service method to be called.
      # - +start_on+ - When date range starts for stats request. OpenX parameter +oStartDate+ which ignores time part of it.
      # - +end_on+ - When date range ends for stats request. OpenX parameter +oEndDate+ which ignores time part of it.
      # - +local_time_zone+ - For v2 of OpenX API only which will respect the local Time Zone. OpenX parameter +localTZ+.
      #
      # With such generic method the gem is able to get any statistics available from the OpenX API, 
      # because all those statistics methods have the same call format.
      def get_statistics service_method, start_on = Date.today, end_on = Date.today, local_time_zone = true
        session = self.class.connection
        
        # For compatibility with v1 of OpenX API.
        if OpenX::Services::Base.configuration["url"].include?("/v1/")
          @server.call(service_method, session, self.id, start_on, end_on)
        else
          @server.call(service_method, session, self.id, start_on, end_on, local_time_zone)
        end
      end
    end
  end
end