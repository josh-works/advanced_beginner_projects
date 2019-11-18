# [programming projects for advanced beginners: ascii art](https://robertheaton.com/2018/06/12/programming-projects-for-advanced-beginners-ascii-art/): josh's notes

per the guide, we're using [Ruby's Minimagick](https://github.com/minimagick/minimagick)

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