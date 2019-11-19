# [programming projects for advanced beginners: ascii art](https://robertheaton.com/2018/06/12/programming-projects-for-advanced-beginners-ascii-art/): josh's notes

per the guide, we're using [Ruby's Minimagick](https://github.com/minimagick/minimagick)

## 0. Choose an image

Used:

```ruby
require 'mini_magick'

image = MiniMagick::Image.open("./images/ascii-pineapple.jpg")

puts "Successfully loaded image!"
puts "image size: #{image.height.to_s} x #{image.width.to_s}"
```

output is:

```
$ ruby experiment.rb
Successfully loaded image!
image size: 467 x 700
```

## 1. Read your image and print its height and width in pixels

Here's what that pixel arrays map to:

``` 
p = image.get_pixels
# p[0][0] p[0][1] p[0][2] p[0][3] p[0][4]
# [[rgb],  [rgb],  [rgb],  [rgb],  [rgb]] # p[0]
# p[1][0] p[1][1] p[1][2] p[1][3] p[1][4]
# [[rgb],  [rgb],  [rgb],  [rgb],  [rgb]] # p[1]
# p[2][0] p[2][1] p[2][2] p[2][3] p[2][4]
# [[rgb],  [rgb],  [rgb],  [rgb],  [rgb]] # p[2]
# p[3][0] p[3][1] p[3][2] p[3][3] p[3][4]
# [[rgb],  [rgb],  [rgb],  [rgb],  [rgb]] # p[3]
# p[4][0] p[4][1] p[4][2] p[4][3] p[4][4]
# [[rgb],  [rgb],  [rgb],  [rgb],  [rgb]] # p[4]
# p[5][0] p[5][1] p[5][2] p[5][3] p[5][4]
# [[rgb],  [rgb],  [rgb],  [rgb],  [rgb]] # p[5]
```

each instance or `rgb` is 3 numbers, each between 0-255, like:

1, 116, 209

Those 3 values are how "intense" the given color of Red, Green, or Blue should be displayed.

OK, this code works:

```ruby
require 'mini_magick'

image = MiniMagick::Image.open("./images/ascii-pineapple.jpg")
pixels = image.get_pixels

puts "Successfully loaded image!"
puts "image size: #{image.height.to_s} x #{image.width.to_s}"

length = pixels.length
width = pixels[0].length

m1 = "the number of arrays the image has represents how tall the image is, or its height. so, image height is #{length.to_s}"
m2 = "Pixel matrix size: " + length.to_s + " x " + width.to_s
puts "iterating through pixel contents"
puts m1
puts m2
pixels.each do |row|
  row.each do |column|
    p column
  end
end
```

Because it generates:

```
Successfully loaded image!
image size: 467 x 700
iterating through pixel contents
the number of arrays the image has represents how tall the image is, or its height. so, image height is 467
Pixel matrix size: 467 x 700
[1, 116, 209]
[1, 116, 209]
[1, 116, 209]
[1, 116, 209]
[1, 116, 209]
[1, 116, 209]
[1, 116, 209]
[1, 116, 209]
[1, 116, 209]
[1, 116, 209]
[1, 116, 209]
[1, 116, 209]
[1, 116, 209]
[1, 116, 209]
[1, 116, 209]
[1, 116, 209]
[2, 115, 207]
[2, 115, 207]
[2, 115, 207]
[2, 115, 207]
[2, 115, 207]
[2, 115, 207]
```


## 3. Convert the RGB tuples of your pixels into single brightness numbers

```ruby
brightness = pixels.map do |row|
  row.map do |col|
    r = col[0]
    g = col[1]
    b = col[2]
    col = (r + b + g) / 3
    p col
  end
end
```



## 4. Convert brightness numbers to ASCII characters

I did so with:

```ruby
require 'mini_magick'

image = MiniMagick::Image.open("./images/ascii-pineapple.jpg")
pixels = image.get_pixels

@shade = "`^\",:;Il!i~+_-?][}{1)(|\\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$".split("").to_a
def convert_to_brightness(col)
  r = col[0]
  g = col[1]
  b = col[2]
  pix = (r + g + b) / 3
  @shade[pix / 4]
end

brightness = pixels.map do |row|
  row.map do |col|
    col = convert_to_brightness(col)
  end
end
p brightness
```

which produces...

![yum](https://cl.ly/800aa1dea733/2019-11-18%20at%208.18%20PM.jpg)

## 5. Print your ASCII art!

Whoa. This is cool. I added a `prep_for_terminal` method:

```ruby
def prep_for_terminal(img)
  img.each do |row|
    p row.join
  end
end
```

and when I run the file and shrink my terminal text way down, I can see the image!

![its me](https://cl.ly/98b25fa92499/2019-11-19%20at%206.54%20AM.jpg)

![ascii-favicon](https://cl.ly/3c5158be58bd/2019-11-19%20at%206.55%20AM.jpg)

Super cool.

## Extension 1: Print your ASCII-art in badass Matrix Green

TBD




