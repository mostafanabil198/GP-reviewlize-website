class ReviewlizeController < ApplicationController
  def home
  end

  def index
    if params[:search_word].match(/[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)/)
      if params[:search_word].match(/(?:https?:\/\/(?:www\.){0,1}amazon\.com(?:\/.*){0,1}(?:\/dp\/|\/gp\/product\/))(.+?)(?:\/.*|$)/)
        @results = AmazonProductDataScrapper.scrape(params[:search_word])
      else
        redirect_to root_path
        # error message Flash
      end
    else
      search_word = params[:search_word]
      @results = AmazonSearchScrapper.scrape(search_word)
    end
  end

  def scrape_product
    product_url = params[:product_url]
    @reviews = AmazonProductScrapper.scrape(product_url)

     response = Faraday.post("http://localhost:5000/predict", {sentences: @reviews}.to_json, "Content-Type" => "application/json")
     render json: response.body

    # response = {"results":{"aspect_analize":{"funny":{"negative":0,"neutral":0,"positive":1},"screen":{"negative":0,"neutral":0,"positive":1},"signs":{"negative":2,"neutral":3,"positive":0},"that":{"negative":0,"neutral":1,"positive":0},"when":{"negative":0,"neutral":1,"positive":0}},"aspects":["that","signs","when","signs","funny","screen"],"filtered":[["signs","minimal"],["signs","when"],["signs","wear"],["signs","damage"],["signs","showed"],["screen","great"],["funny","kind"],["when","notes"],["that","do"]]}}
    # render json: response.to_json
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