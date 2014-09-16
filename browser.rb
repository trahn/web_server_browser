require 'socket'
require 'json'

host = 'localhost'
port = 2000

while true
  puts "GET or POST request?"
  input = gets.chomp.downcase
  case input
  when 'get'
    request = "GET /index.html HTTP/1.0\r\n\r\n"
    break
  when 'post'
    puts "You are registering a new viking."
    result = {:viking => {}}
    print "Name: "
    result[:viking][:name] = gets.chomp
    print "Email: "
    result[:viking][:email] = gets.chomp
    contents = result.to_json
    request = "POST /thanks.html HTTP/1.0\nFrom: #{result[:viking][:email]}\nUser-Agent: HTTPTOOL/1.0\nContent-Type: simple post\nContent-Length: #{contents.size}\r\n\r\n#{contents}"
    break
  else
    puts "Try again:"
  end
end

socket = TCPSocket.open(host,port)
socket.print(request)
response = socket.read

headers,body = response.split("\r\n\r\n", 2)
print body
socket.close