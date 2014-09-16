require 'socket'
require 'json'

def get(path)
  begin
    file = File.open(path[1..-1], 'r')
  rescue
    return "HTTP/1.0 404 Not Found"
  else
    contents = file.read 
    size = file.size
    type = path.split(".").last
    file.close
    "HTTP/1.0 200 OK\nDate: #{Time.now.gmtime.strftime("%a, %e %b %Y %H:%M:%S GMT")}\nContent-Type: text/#{type}\nContent-Length: #{size}\r\n\r\n#{contents}"
  end
end

def post(path, body)
  params = JSON.parse(body)
  begin
    file = File.open(path[1..-1], 'r')
  rescue
    return "HTTP/1.0 404 Not Found"
  else
    contents = file.read
    size = file.size
    type = path.split(".").last
    file.close
    json_html = ""
    params['viking'].each do |key, value|
      json_html += "<li>#{key.capitalize}: #{value}</li>"
    end
    contents = contents.sub("<%= yield %>",json_html)
    "HTTP/1.0 200 OK\nDate: #{Time.now.gmtime.strftime("%a, %e %b %Y %H:%M:%S GMT")}\nContent-Type: text/#{type}\nContent-Length: #{size}\r\n\r\n#{contents}"
  end
end

server = TCPServer.open(2000)

loop do
  Thread.start(server.accept) do |client|
    request = client.recv(1000)
    headers,body = request.split("\r\n\r\n", 2)
    method, path, http = headers.split("\n")[0].strip.split(" ")
    case method
    when 'GET'
      client.puts get(path)
    when 'POST'
      client.puts post(path, body)
    else
      client.puts(Time.now.ctime)
      client.puts "Closing the connection. Bye!"
    end
    client.close
  end
end