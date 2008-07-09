module OpenX
  class Image
    include XMLRPC::Marshallable
    attr_accessor :filename, :content, :editswf

    def initialize(hash_or_file)
      @editswf = 0
      if hash_or_file.is_a?(File)
        @filename = File.basename(hash_or_file.path)
        @editswf = File.basename(@filename, '.swf') == @filename ? 0 : 1
        @content  = XMLRPC::Base64.new(hash_or_file.read)
      else
        raise ArgumentError unless hash_or_file.key?(:filename)
        raise ArgumentError unless hash_or_file.key?(:content)
        hash_or_file.each { |k,v| send(:"#{k}=", v) }
        unless self.content.is_a?(XMLRPC::Base64)
          self.content = XMLRPC::Base64.new(self.content)
        end
      end
    end
  end
end
