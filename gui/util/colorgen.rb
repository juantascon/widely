# Return true if the difference between two colors 
# matches the W3C recommendations for readability
# See http://www.wat-c.org/tools/CCA/1.1/
def colors_diff_ok? c1, c2
  cont, bright = find_color_diff c1, c2
  (cont > 500) && (bright > 125) # Acceptable diff according to w3c
end

# Return the contranst and brightness difference between two RGB values
def find_color_diff c1, c2
  r1, g1, b1 = break_color c1
  r2, g2, b2 = break_color c2
  cont_diff = (r1-r2).abs+(g1-g2).abs+(b1-b2).abs # Color contrast
  bright1 = (r1 * 299 + g1 * 587 + b1 * 114) / 1000
  bright2 = (r2 * 299 + g2 * 587 + b2 * 114) / 1000
  brt_diff = (bright1 - bright2).abs # Color brightness diff
  [cont_diff, brt_diff]
end

# Break a color into the R, G and B components    
def break_color rgb
  r = (rgb & 0xff0000) >> 16
  g = (rgb & 0x00ff00) >> 8
  b = rgb & 0x0000ff
  [r,g,b]
end

########

possible_colors = [0xff0000, 0x00ff00, 0x0000ff, 0xffff00, 0x00ffff, 0xffffff]
good_color = 0 # We can default to black...
possible_colors.each do |c|
  if colors_diff_ok? c, my_color
    good_color = c
    break
  end
end

