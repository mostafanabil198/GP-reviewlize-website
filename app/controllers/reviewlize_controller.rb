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

    # uri = URI('https://bearer.sh')
    # response = Net::HTTP.post_form(uri, 'sentences[]' => @reviews)

    
    puts response.code, response.body

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

# def http_get(domain,path,params)
#     return Net::HTTP.get_response(domain, "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))) if not params.nil?
#     return Net::HTTP.get(domain, path)
# end

# params = {:q => "ruby", :max => 50, :sentences => ["sasdas", "asfasf asfas ", "Asgasg"]}
# print http_get("www.example.com", "/search.cgi", params)
