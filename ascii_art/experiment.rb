require 'mini_magick'

# image = MiniMagick::Image.open("../ascii_art/images/climbing.jpg")
image = MiniMagick::Image.open("./images/apple-touch-icon.png")
pixels = image.get_pixels

if pixels.length > 600
  pixels = image.resize(600).get_pixels
end

@shade = "`^\",:;Il!i~+_-?][}{1)(|\\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$".split("").to_a
def convert_to_brightness(col)
  r = col[0]
  g = col[1]
  b = col[2]
  pix = (r + g + b) / 3
  char = @shade[pix / 4]
  char + char + char
end

brightness = pixels.map do |row|
  row.map do |col|
    col = convert_to_brightness(col)
  end
end

def prep_for_terminal(img)
  img.each do |row|
    p row.join
  end
end

prep_for_terminal(brightness)

