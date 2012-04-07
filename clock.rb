class Point
  attr_accessor :x, :y
  def initialize(argx,argy)
    self.x = argx
    self.y = argy
  end
end
OP = Point.new(150,150) #Origin Point

def setup
  size 300, 300
  screen_clear
end

def draw
  clock_work
end

def screen_clear
  background(255)
  ellipse(OP.x,OP.y,300,300)
end

def draw_arm(start_point,angle,length)
  x = start_point.x
  y = start_point.y
  rad = angle * Math::PI / 180
  x += Math.sin(rad) * length
  y += Math.cos(rad) * length
  line(start_point.x, start_point.y, x, y)
end

def clock_work
  screen_clear

  now = Time.now
  
  #秒針
  angle = now.sec * -6 + 180
  draw_arm(OP,angle,150)

  #分針
  angle = now.min * -6 + 180
  draw_arm(OP,angle,130)

  #時針
  angle = ((now.hour - 12) * -30 + 180) - (now.min * 0.5)
  draw_arm(OP,angle,100)
end
