# working through [programming projects for advanced beginners: ascii art](https://robertheaton.com/2018/06/12/programming-projects-for-advanced-beginners-ascii-art/)

per the guide, we're using [Ruby's Minimagick](https://github.com/minimagick/minimagick)


### Notes from Josh

I often outline my thought processes as I move through programming projects, for work or personal programming. This document is no exception. 

If someone is reading this, and wants to run the code locally, clone down the repo and CD into the appropriate directory:

```shell
$ git clone git@github.com:josh-works/advanced_beginner_projects.git
$ cd advanced_beginner_projects/ascii-art

# brew install imagesnap if you don't have it:
$ brew install imagesnap

# now you can start interacting w/the program.
# convert a random pic of me to ascii-art:

$ ruby experiment.rb

# run it in selfie mode:
$ ruby experiment.rb selfie

# invert colors
$ ruby experiment.rb selfie invert

# use various image brightness patterns:
$ ruby experiment.rb               # defaults to average
$ ruby experiment.rb min-max                 
$ ruby experiment.rb average
$ ruby experiment.rb luminosity

# mix all of the above:
$ ruby experiment.rb selfie invert luminosity
```

There's a lot of room for refactoring; I've recently been working through Sandi Metz' Practical Object Oriented Design in Ruby_, and... well, reading that book and writing this code makes my eyes bleed a little, but I'm not sure how to think about it differently. 

I'm afraid that what I would do would be minor rearranging the deck chairs on the Titanic, rather than fundamental and substantial improvements in the organization of this code. 

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

Oh, this is just changing my terminal color.

I was thinking I'd be adding color elements to the output, but we'll do that in extension 5. 

This one is easy:

![its green](https://cl.ly/b9c9dbf569c3/2019-11-19%20at%208.40%20AM.jpg)

Scratch that. You can use Ruby to print strings in various colors, per [This StackOverflow answer](https://stackoverflow.com/a/16363159/3210178)

Lovely. Here it is, being red, but with terminal escape characters, instead of just using my Terminal's GUI to change the output:

![red output](https://cl.ly/3ca4dc96af7f/2019-12-03%20at%206.55%20AM.jpg)

## Extension 2: Implement the min/max and luminosity brightness mappings from section 3

> Add a setting to your program that can be set to either “average”, “min_max” ((max(R, G, B) + min(R, G, B)) / 2 - see section 3) or “luminosity” (0.21 R + 0.72 G + 0.07 B), and use if-statements to select the appropriate brightness mapping depending on what it is set to.


Got it working. I first just rolled through the code one pixel at a time, making sure I was getting different brightness values. You can see some of the printed values in commit `681a5a2`

I was having trouble visually confirming a difference, so I did this:

![differences](https://cl.ly/ab532e4e4d6e/2019-12-03%20at%207.46%20AM.jpg)

It's all working!

Interaction pattern is:

```
$ ruby experiment.rb                         // defaults to average
$ ruby experiment.rb min-max                 
$ ruby experiment.rb average
$ ruby experiment.rb luminosity
```

## Extension 3: Add the option to invert all the brightnesses, so dark becomes light and light becomes dark

I'll add an `invert` flag to the CLI args, that will pick from the opposite side of the brightness array. 

Boom. Success:

![inverting colors](https://cl.ly/2aea4173514d/2019-12-03%20at%208.03%20AM.jpg)

Added this extension in commit `a147409`

## Extension 4: Print pictures from your webcam

This is... super cool. And surprisingly easy! What an amazing world. With two lines of code I can use a _free_ library that grabs images from my webcam. 

I don't know how many hours [Robert Harder](https://github.com/rharder) spent on [imagesnap](https://github.com/rharder/imagesnap), but... quite a few. And the world is better off!

Anyway, it's easy to grab a picture from the webcam:

```
$ imagesnap
```
and this saves the new screenshot as `snapshot.jpg`, by default, in the directory where the command was run. 

I can easily pass that file to my terminal program by manually updating the filepath. 

To make this work end-to-end, I'll need to update the command line arguments, and let my program call `imagesnap` from inside of it. 

Robert Heaton points Ruby-folk towards [popen](https://ruby-doc.org/core-2.6.5/IO.html#method-c-popen). 

Cool. If one passes `selfie` to the ruby program, it'll take a picture from the webcam, and process it normally. `invert` still works. 

##### Regular:

![regular](https://cl.ly/43b9acf8151c/2019-12-03%20at%208.32%20AM.jpg)

#####

![inverted](https://cl.ly/c121713ae2f3/2019-12-03%20at%208.33%20AM.jpg)

Made the update in commit `654bfd0`

## Extension 5: Print your ASCII art in glorious color

This is thought-provoking:

> up until now you’ve been throwing away color information when you convert your pixel matrix into an intensity matrix.

So, how do I retain some color? Robert gives some suggestions:

> You don’t have to print the entire image in color. 
> 
> You could add some subtle artsy accents on pixels that are almost entirely Red, Blue or Green (for example pixels with the values (240, 3, 10), (13, 226, 18) or (0, 0, 255)) and print the rest in black and white. 
> 
> Or choose pixels colors based on a flag overlay, whilst keeping the brightnesses of the underlying image.

I sure am throwing away a ton of data when converting to brightness. 

I wonder what it'll look like if I convert a given pixel to that symbol _and_ wrap it in a given color?

For example, if a pixel comes in as `[10, 134, 210]`, my `pixel_brightness_average` function combines the `rgb` values, divides by 3, and goes and fetches a given character for brightness. In this case, it would be `118`, which is 46% of the way through the given `shading` scale. 

I'd still like to get that 46% brightness, but I suppose I'll have to include an optional color scheme to it. 

I've got this bit of code:

```ruby
def black;          "\e[30m#{self}\e[0m" end
def red;            "\e[31m#{self}\e[0m" end
def green;          "\e[32m#{self}\e[0m" end
def brown;          "\e[33m#{self}\e[0m" end
def blue;           "\e[34m#{self}\e[0m" end
def magenta;        "\e[35m#{self}\e[0m" end
def cyan;           "\e[36m#{self}\e[0m" end
def gray;           "\e[37m#{self}\e[0m" end
```

Which makes me think I can certainly apply a color to a character. 

I'm going to try randomly adding colors to pixels.

Lets do it here:

```ruby
def widen_char(char)
  joined = char + char + char
  if rand < 0.3
    joined.green
  else
    joined
  end
end
```

Nailed it. This is _exactly_ that Instagram Filter I was going for. Which was it? oh yeah, `mold`:

![moldy AF](https://cl.ly/9557f392ac51/2019-12-03%20at%206.42%20PM.jpg)


Now lets add `String.green` to any pixel that is strong in the green dimension. 

I have to start _at least_ from a method that still knows the color of the character. In this case:

```ruby
def pixel_brightness_average(col)
  r, g, b = col
  brightness = (r + g + b) / 3.0
  
  char = pick_appropriate_brightness(brightness)
  widen_char(char)
end
```
and with this small modification:

```ruby
def pixel_brightness_average(col)
  r, g, b = col
  brightness = (r + g + b) / 3.0
  
  char = pick_appropriate_brightness(brightness)
  char = char.green if g > 200 
  widen_char(char)
end
```

We get this monstrosity: 

![it's aliiiiiive](https://cl.ly/8db9c6ac11b1/2019-12-03%20at%206.52%20PM.jpg)

Lets try to apply the green a bit more sparingly.

I added this `apply_green_ish` method:

```ruby
  def apply_green_ish(col, char)
    r, g, b = col
    if r < 150 && b < 150 && g > 150
      return char.green
    else
      char
    end
  end
```

It sorta works. I hardly remember the original picture, but we've got green applied only to certain pixels:

![partial green](https://cl.ly/5b8babca31f8/2019-12-03%20at%206.58%20PM.jpg)

Lets get this working only in the three primary colors:

```ruby
def colorize_rgb(col, char)
  r, g, b = col
  if r < 150 && b < 150 && g > 150
    return char.green
  elsif r > 150 && b < 150 && g < 150
    return char.red
  elsif r < 150 && b > 150 && g < 150
    return char.blue
  else
    char
  end
end
```

This method is... beautiful in its simplicity.

`</sarcasm>`

Well, this picture makes me look more patriotic than I actually am:

![red, white, and blue](https://cl.ly/9fd9ec11bc67/2019-12-03%20at%207.01%20PM.jpg)

Lets get more green and less red. 

Tweaking some values - the mold is back, but I'm less patriotic. I'd say win-win:

![moldy flag](https://cl.ly/78151df01853/2019-12-03%20at%207.03%20PM.jpg)

Great! I've added the above function, and everything works (including selfies on the webcam) as expected.

Added it all in commit `1c30d30`



