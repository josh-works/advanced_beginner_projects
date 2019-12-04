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

# This whole selfie if statement feels very wrong
@selfie = ARGV.delete("selfie")
if @selfie
  p "about to take picture..."
  new_picture = IO.popen("imagesnap snapshot.jpg")
  # what if someone doesn't have imagesnap installed?
  new_picture.read
  # this was how I forced the program to wait until the webcam took a picture
  # otherwise it would start taking a picture, and use the existing snapshot.jpg, 
  # rather than waiting for it to finish.
  image = MiniMagick::Image.open("snapshot.jpg")
else
  image = MiniMagick::Image.open("../ascii_art/images/climbing.jpg")
end

# image = MiniMagick::Image.open("./images/apple-touch-icon.png")
pixels = image.get_pixels

if pixels.length > 600
  pixels = image.resize(500).get_pixels
end

# determine if we ought to invert colors and remove setting from args array
@invert = ARGV.delete("invert") 

p "please choose from 'average', 'min-max', and 'luminosity'. Default is 'average'"
# this assumes the only argument left is related to brightness setting
brightness_setting = ARGV[0] || "average"
p brightness_setting


@shading = "`^\",:;Il!i~+_-?][}{1)(|\\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$".split("").to_a
@range = @shading.count

def get_character_from_shading_array(index)
  if @invert
    @shading[-index]
  else
    @shading[index]
  end
end

def pick_appropriate_brightness(pix)
  # abs_brightness is between 0-255, w/pix somewhere between.
  
  # abs_brightness represents percentage of max range I want (between 0-100)
  brightness_percent = pix / 255.0
  
  # then grab character from @shading that is that percent of the way through the group
  index = (brightness_percent * @range).round - 1
  
  get_character_from_shading_array(index)
end

def widen_char(char)
  char + char + char
end

def pixel_brightness_average(col)
  r, g, b = col
  brightness = (r + g + b) / 3.0
  
  char = pick_appropriate_brightness(brightness)
  char = colorize_rgb(col, char) 
  widen_char(char)
end

def colorize_rgb(col, char)
  r, g, b = col
  case 
  when r < 150 && b < 150 && g > 100
    return char.green
  when r > 140 && b < 110 && g < 110
    return char.red
  when r < 100 && b > 110 && g < 100
    return char.blue
  else
    char
  end
end

def pixel_min_max(col)
  r, g, b = col
  brightness = ([r, g, b].min + [r, g, b].max) / 2.0
  char = pick_appropriate_brightness(brightness)
  char = colorize_rgb(col, char)
  widen_char(char)
end

def pixel_luminosity(col)
  r, g, b = col
  brightness = (r * 0.21) + (g * 0.72) + (b * 0.07)
  char = pick_appropriate_brightness(brightness)
  char = colorize_rgb(col, char)
  widen_char(char)
end

converted_image = pixels.map do |row|
  row.map do |col|
    case brightness_setting
    when "average"
      col = pixel_brightness_average(col)
    when "min-max"
      col = pixel_min_max(col)
    when "luminosity"
      col = pixel_luminosity(col)
    end
  end
end

def prep_for_terminal(img)
  img.each do |row|
    puts row.join
  end
end

prep_for_terminal(converted_image)
p "feel free to do it again, passing in a different luminosity scheme:"
p "please choose from 'average', 'min-max', and 'luminosity'. Default is 'average'"
p "additionally, you can pass 'invert' as a second CLI argument to invert colors"

