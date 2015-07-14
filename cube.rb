# How to play:
# $ rp5 live cube.rb
# irb(main):001:0> $rotation_rate = 0.05
# #=> 0.05
# irb(main):002:0> $app.noStroke
# #=> nil
# irb(main):003:0> $light=lambda{$app.lights}
# #=> #<Proc:0x19ab00e@(irb):3>
# irb(main):004:0> $zoom_speed = 3
# #=> 3
# et cetera..

#load_libraries :opengl, :boids
$size=50
$zoom = true
$light = lambda {
  $app.ambientLight(255,255,255)
}

def setup
  init_val
  size 380, 380, P3D
  smooth
  frame_rate 30
end

def draw
  background($backcolor)
  translate($pos[:x], $pos[:y], 0); 
  if $size > 200 && $zoom
    $zoom = false
  elsif $size < 50 && !$zoom
    $zoom = true
  end
  $size += $zoom_speed if $zoom 
  $size -= $zoom_speed unless $zoom 

  $light.call
  rotateX(frameCount * $rotation_rate);
  rotateY(frameCount * $rotation_rate);
  rotateZ(frameCount * $rotation_rate);
  fill($fill_color)
  case $shape
  when :box
    box($size)
  when :sphere
    sphere($size)
  end
end

def init_val
  pointLight(50,100,180,80,20,40)
  $rotation_rate = 0 #0.01
  $zoom_speed    = 0 #2
  $pos = {:x=>190, :y=>190}
  $fill_color    = rgb(255,0,0)
  $shape         = :box
  $backcolor     = 0 #255
end
