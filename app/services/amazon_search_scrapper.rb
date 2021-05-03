class AmazonSearchScrapper < Kimurai::Base
  @@search_results = []
  def self.scrape(search_word)
    @@search_results.clear
    @@search_word = search_word
    self.crawl!
    return @@search_results
  end
  @name = "amazon_search_scrapper"
  # @engine = :selenium_chrome
  @start_urls = ["https://www.amazon.com/"]

  def parse(response, url:, data: {})
    browser.fill_in "field-keywords", with: @@search_word
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
      @@search_results << {title: title, price: price, url: url, image: image}
    end
  end
end