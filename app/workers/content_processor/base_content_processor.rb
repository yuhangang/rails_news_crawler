module ContentProcessor
# Base content processor with common functionality
class BaseContentProcessor
  def process(doc, base_url)
    clean_document(doc)
    process_images(doc)
    content = extract_content(doc, base_url)
    wrap_content(content)
  end

  protected

  def clean_document(doc)
    doc.css("script, style, iframe, nav, header, footer, .advertisement, .social-share, .comments").remove
  end

  def process_images(doc)
    doc.css("img").each do |img|
      image_url = img["data-lazy"] || img["data-src"] || img["src"]
      img.attribute_nodes.each { |attr| img.remove_attribute(attr.name) }
      img["src"] = image_url if image_url
    end
  end

  def clean_links(element, base_url)
    element.css("a").each do |link|
      if link.text.strip.empty? || link["href"]&.start_with?("javascript")
        link.remove
      else
        href = link["href"]
        if href && !href.start_with?("http")
          base_uri = URI.parse(base_url)
          link["href"] = URI.join(base_uri, href).to_s
        end
      end
    end
  end

  def wrap_content(content_parts)
    "<article>#{content_parts.join("").strip.gsub(/\n+/, "")}</article>"
  end

  def find_main_content(doc)
    doc.at_css("article, .article, .post, .content, main, #main-content") || doc
  end

  def extract_content(doc, base_url)
    raise NotImplementedError, "Subclasses must implement extract_content"
  end
end
end
