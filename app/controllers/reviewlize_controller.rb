class ReviewlizeController < ApplicationController
  def home
    
  end

  def index
    search_word = params[:search_word]
    @results = AmazonSearchScrapper.scrape(search_word)
    puts @results.size
    puts @results.first
  end

  def show
    product_url = params[:product_url]
    @reviews = AmazonProductScrapper.scrape(product_url)
  end
end