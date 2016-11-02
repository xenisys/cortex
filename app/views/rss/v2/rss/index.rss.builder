if Rails.cache.fetch("rss-v2-#{content_type.name}")
  xml << Rails.cache.fetch("rss-v2-#{content_type.name}")
end

Rails.cache.fetch("rss-v2-#{content_type.name}", expires_in: 1.hours, race_condition_ttl: 10) do
  xml.instruct! :xml, :version => "1.0"
  xml.rss :version => "2.0" do
    xml.channel do
      rss_decorator.each_pair do |key, value|
        unless key == "items"
          xml.tag! key, value
        end
      end

      @content_items.each_with_index do |rss_content_item|
        xml.item do
          rss_decorator['items'].each_pair do |key, value|
            if value.keys.include?("encoded")
              xml.tag! "#{key}:encoded" do
                xml.cdata! get_tag_data(value, rss_content_item)
              end
            else
              xml.tag! key, get_tag_data(value, rss_content_item)
            end
          end
        end
      end
    end
  end
end
