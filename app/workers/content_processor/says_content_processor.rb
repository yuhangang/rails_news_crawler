module ContentProcessor
# Content processor for Says.com
class SaysContentProcessor < BaseContentProcessor
  def clean_document(doc)
    super
    # Says-specific cleanup
    doc.css(".share-buttons, .story-bottom, .ga-curator-related, .hashtags, .video-title").remove
  end

  def extract_content(doc, base_url)
    clean_document(doc)

    main_content = find_main_content(doc)
    content_parts = []

    # Says-specific title extraction (adjust selectors as needed)
    if title = main_content.at_css(".article-title, .story-title")
      content_parts << title.to_html.strip
    end

    # Says-specific metadata extraction
    if metadata = main_content.css(".article-info, .story-info").first
      content_parts << metadata.to_html.strip
    end

    # Says-specific content elements
    content_elements = main_content.css(
      "p, h2, h3, h4, h5, h6, ul, ol, blockquote, .story-image, .article-image"
    )

    process_content_elements(content_elements, content_parts, base_url)
    content_parts
  end

  private

  def process_content_elements(elements, content_parts, base_url)
    elements.each do |element|
      next if element.text.strip.empty? && !element.matches?(".story-image, .article-image")

      if element.matches?(".story-image, .article-image")
        process_says_image(element, content_parts)
      else
        clean_links(element, base_url)
        content_parts << element.to_html unless element.to_html.empty?
      end
    end
  end

  def process_says_image(element, content_parts)
    img = element.at_css("img")
    return unless img && img["src"] && !img["src"].include?("tracking")

    img_parts = [ "<figure>", img.to_html.strip ]
    if caption = element.at_css(".image-caption, .story-image-caption")
      img_parts << caption.to_html.strip
    end
    img_parts << "</figure>"
    content_parts << img_parts.join("")
  end
end
end
