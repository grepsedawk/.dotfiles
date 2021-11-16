#!/usr/bin/env ruby

require 'chunky_png'

BASE =  '#22212c'

COLORS = %w[
  #f8f8f2
  #454158
  #504c67
  #FF9580
  #FFAA99
  #8AFF80
  #A2FF99
  #9580FF
  #AA99FF
  #FF80BF
  #FF99CC
  #80FFEA
  #99FFEE
]

resolution = `xdpyinfo | awk '/dimensions/ {print $2}'`.strip.split('x').map(&:to_i)

WIDTH = resolution[0]
HEIGHT = resolution[1]

png = ChunkyPNG::Image.new(WIDTH, HEIGHT, ChunkyPNG::Color.from_hex(BASE))

def add_spot(png)
  size = rand(50..200)
  spot = [rand(0..WIDTH), rand(0..HEIGHT)]

  minx = spot[0] - size
  minx = 0 if minx.negative?

  maxx = spot[0] + size
  maxx = WIDTH - 1 if maxx >= WIDTH

  miny = spot[1] - size
  miny = 0 if miny.negative?

  maxy = spot[1] + size
  maxy = HEIGHT - 1 if maxy >= HEIGHT
  color = COLORS.sample
  (minx..maxx).each do |x|
    (miny..maxy).each do |y|
      png[x, y] = ChunkyPNG::Color.from_hex(color)
    end
  end
end

50.times do
  add_spot(png)
end

png.save('/tmp/wallpaper.png', :fast_rgba)
