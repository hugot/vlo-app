require 'net/http'
require 'nokogiri'

# This will be the entry point for the API

class VloApi
  URL = 'vlo.informatica.hva.nl'
  PORT = 443

  def initialize(uname, pw)
    @cookie = nil
    @http = Net::HTTP.new('vlo.informatica.hva.nl', 443)
    @http.use_ssl= true
    @uname = uname
    @pw = pw
  end

  def login(uri_str = "https://#{URL}/index.php", limit = 10, get = false, cookie = nil)
    if limit == 0
      warn 'Login redirection limit has been exceeded'
      return false
    end

    if get == true
      request = Net::HTTP::Get.new(uri_str)
      request['Cookie'] = cookie.to_s
      request['User-Agent'] = 'Mozilla/5.0 (X11; Linux x86_64; rv:57.0) Gecko/20100101 Firefox/57.0'
      response = @http.request(request)
    else
      response = Net::HTTP.post_form(
        URI(uri_str),
        {
          'login' => @uname,
          'password' => @pw
        }
      )
    end

    logged_in = response.body.include? 'd="user_image_block"'

    case response
    when Net::HTTPSuccess then
      if logged_in == true
        @cookie = cookie 
        debug "Login OK"
        debug "Setting cookie to #{cookie.to_s}"
      else
        debug "Failed to login with response code #{response.code}"
      end
      return logged_in
    when Net::HTTPRedirection then
      location = response['location']
      cookie = response['Set-Cookie']
      debug "redirected to #{location}"
      return login(location, limit - 1, true, cookie)
    else
      debug "Failed to login with response code #{response.code}"
      return logged_in
    end
  end


  def get_page(page)
    url = "https://#{URL}/#{page}"
    if @cookie == nil
      return nil if login != true
    end
    request = Net::HTTP::Get.new(url)
    request['Cookie'] = @cookie.to_s
    request['User-Agent'] = 'Mozilla/5.0 (X11; Linux x86_64; rv:57.0) Gecko/20100101 Firefox/57.0'
    response = @http.request(request)
    case response
    when Net::HTTPSuccess then
      debug "Response code: #{response.code}"
      if response.body.include? 'see this page'
        debug "Not allowed to see page"
      end
      return response.body
    else
      debug "Error: no http OK code when requesting #{url}"
      return response.body
    end
  end

  def find_personal_course
    html = Nokogiri::HTML(get_page('/user_portal.php'))
    elem = html.css('h4[class=course-items-title]')
    courses = elem.css('a').to_a
    real_courses = []
    courses.each do |course|
      if course.text != nil && course.text != ""
        real_courses.push({
          :name => course.text.gsub(/^\s+|\n|\s+$/,''),
          :url  => course["href"]
        })
      end
    end
    return real_courses
  end

end
