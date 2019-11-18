require 'mini_magick'

image = MiniMagick::Image.open("./images/ascii-pineapple.jpg")

puts "Successfully loaded image!"
puts "image size: #{image.height.to_s} x #{image.width.to_s}"

