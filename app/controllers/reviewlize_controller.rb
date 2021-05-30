class ReviewlizeController < ApplicationController
  def home
  end

  def index
    search_word = params[:search_word]
    @results = AmazonSearchScrapper.scrape(search_word)
  end

  def scrape_product
    product_url = params[:product_url]
    @reviews = AmazonProductScrapper.scrape(product_url)
    render json: @reviews
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

    @products = []
    params[:products].each do |prod|
      prod = eval(prod)
      product = Product.find_by(url: prod[:url])
      if product.present?
        @products << product
      else
        @products << Product.create(name: prod[:title], url: prod[:url], image_url: prod[:image], price: prod[:price], supported_website: SupportedWebsite.find_by(base_url: "#{prod[:url].split('.com').first}.com"))
      end
    end

    if @products.size > 1
      @comparison = true
    else
      @comparison = false
    end 

  end
end