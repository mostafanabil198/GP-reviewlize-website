class AmazonSearchScrapper < Kimurai::Base
  def self.scrape(search_word)
    # self.crawl!
    return self.parse!(:parse, url: "https://www.amazon.com/?#{search_word}")
  end
  @name = "amazon_search_scrapper"
  # @engine = :selenium_chrome
  @start_urls = ["https://www.amazon.com/"]

  def parse(response, url:, data: {})
    @search_results = []
    browser.fill_in "field-keywords", with: url.split("?").last
    browser.click_on "Go"

    # Update response to current response after interaction with a browser
    response = browser.current_response

    # Collect results
    response.css(".s-result-item.s-asin.sg-col-0-of-12.sg-col-16-of-20.sg-col.sg-col-12-of-16").first(5).each do |a|
      url = a.css("h2 a.a-link-normal.a-text-normal").attribute('href').value
      if a.css("span.aok-inline-block.s-sponsored-label-info-icon").count > 0 
        url = CGI.unescape(url.split("url=").last)
      end 
      url = url.split("?").first.split("ref").first
      # puts("=-=-=-=-=-=-=") 
      url = "https://www.amazon.com#{url}"
      title = "#{a.css("span.a-size-medium.a-color-base.a-text-normal").text.squish}"
      image = "#{a.css("img").attribute('src').value}"
      price = "#{a.css(".a-price-whole").text.squish}#{a.css(".a-price-fraction").text.squish}#{a.css(".a-price-symbol").text.squish}"
      # puts("=-=-=-=-=-=-=")
      @search_results << {title: title, price: price, url: url, image: image}
    end
    return @search_results
  end
end