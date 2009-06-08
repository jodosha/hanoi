# shut up, webrick :-)
class ::WEBrick::HTTPServer
  def access_log(config, req, res)
    # nop
  end
end

class ::WEBrick::BasicLog
  def log(level, data)
    # nop
  end
end

class WEBrick::HTTPResponse
  alias send send_response
  def send_response(socket)
    send(socket) unless fail_silently?
  end
  
  def fail_silently?
    @fail_silently
  end
  
  def fail_silently
    @fail_silently = true
  end
end

class WEBrick::HTTPRequest
  def to_json
    headers = []
    each { |k, v| headers.push "#{k.inspect}: #{v.inspect}" }
    headers = "{" << headers.join(', ') << "}"
    %({ "headers": #{headers}, "body": #{body.inspect}, "method": #{request_method.inspect} })
  end
end

class WEBrick::HTTPServlet::AbstractServlet
  def prevent_caching(res)
    res['ETag'] = nil
    res['Last-Modified'] = Time.now + 100**4
    res['Cache-Control'] = 'no-store, no-cache, must-revalidate, post-check=0, pre-check=0'
    res['Pragma'] = 'no-cache'
    res['Expires'] = Time.now - 100**4
  end
end

class BasicServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(req, res)
    prevent_caching(res)
    res['Content-Type'] = "text/plain"
    
    req.query.each do |k, v|
      res[k] = v unless k == 'responseBody'
    end
    res.body = req.query["responseBody"]
    
    raise WEBrick::HTTPStatus::OK
  end
  
  def do_POST(req, res)
    do_GET(req, res)
  end
end

class SlowServlet < BasicServlet
  def do_GET(req, res)
    sleep(2)
    super
  end
end

class DownServlet < BasicServlet
  def do_GET(req, res)
    res.fail_silently
  end
end

class InspectionServlet < BasicServlet
  def do_GET(req, res)
    prevent_caching(res)
    res['Content-Type'] = "application/json"
    res.body = req.to_json
    raise WEBrick::HTTPStatus::OK
  end
end

class NonCachingFileHandler < WEBrick::HTTPServlet::FileHandler
  def do_GET(req, res)
    super
    set_default_content_type(res, req.path)
    prevent_caching(res)
  end

  def set_default_content_type(res, path)
    res['Content-Type'] = case path
      when /\.js$/   then 'text/javascript'
      when /\.html$/ then 'text/html'
      when /\.css$/  then 'text/css'
      else 'text/plain'
    end
  end
end
