require 'mini_magick'

class String
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end

  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end

  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end
end


# image = MiniMagick::Image.open("../ascii_art/images/climbing.jpg")
image = MiniMagick::Image.open("./images/apple-touch-icon.png")
pixels = image.get_pixels

if pixels.length > 600
  pixels = image.resize(600).get_pixels
end

@shading = "`^\",:;Il!i~+_-?][}{1)(|\\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$".split("").to_a

def pixel_brightness_average(col)
  r = col[0]
  g = col[1]
  b = col[2]
  pix = (r + g + b) / 3
  char = @shading[pix / 4]
  char + char + char
end

def pixel_min_max(col)
  r, g, b = col
  brightness = ([r, g, b].min + [r, g, b].max) / 2
  char = @shading[brightness / 4]
  char + char + char
end


converted_image = pixels.map do |row|
  row.map do |col|
    col = pixel_min_max(col)
    # col = pixel_brightness_average(col)
  end
end

def prep_for_terminal(img)
  img.each do |row|
    puts row.join.red
  end
end

puts "I'm back green".cyan
puts "I'm red and back cyan".red
puts "I'm bold and green and backround red".green

prep_for_terminal(converted_image)

