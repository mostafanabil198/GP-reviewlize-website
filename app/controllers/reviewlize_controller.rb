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

  def one_product_analysis
    @products = params[:products]
  end

  def analyze
    # params => links of products
    # 2 options
      # analyze one products
        # redirect l controller bta3ha
      # comparison analysis
        # redirect l controller bta3ha
    params[:products].each do |prod|
      puts eval(prod)[:url]
    end
  end
end