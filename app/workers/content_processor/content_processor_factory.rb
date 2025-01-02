module ContentProcessor
# Base content processor with factory method
class ContentProcessorFactory
  def self.create(publisher_slug)
    case publisher_slug.downcase
    when "says"
      ContentProcessor::SaysContentProcessor.new
    else
       raise NotImplementedError, "No content processor available for publisher: #{publisher_slug}"
    end
  end
end
end
