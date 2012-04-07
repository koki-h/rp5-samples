#load_libraries :opengl, :boids
class Obj
  module Motion
    Zoom = lambda {|obj|
      obj.instance_eval{
        if @z > 200 && @zoom
          @zoom = false
        elsif @z < 50 && !@zoom
          @zoom = true
        end
      if @zoom
        @z += @speed
      else
        @z -= @speed
      end
      }
    }
    Circle = lambda {|obj|
      obj.instance_eval{
        @op ||= {:x=>190, :y=>190, :z=>95}
        @r  ||= sqrt((@op[:x] - @x)**2 + (@op[:y] - @y)**2)
        return if @r <= 0
        rad_speed = (@speed * Math::PI) / 180
        @angle ||= 0.5 * Math::PI if (@x - @op[:x])
        @angle ||= Math.atan((@y - @op[:y]) / (@x - @op[:x])) 
        @angle += rad_speed
        @angle = 0 if @angle > 20 * Math::PI #to prevent overflow

        @x = (Math.cos(@angle) * @r) + @op[:x]
        @y = (Math.sin(@angle) * @r) + @op[:y]
      }
    }
    Circle2 = lambda {|obj|
      obj.instance_eval{
        @op ||= {:x=>190, :y=>190, :z=>0}
        @r  ||= sqrt((@op[:x] - @x)**2 + (@op[:z] - @z)**2)
        return if @r <= 0
        rad_speed = (@speed * Math::PI) / 180
        @angle ||= 0.5 * Math::PI if (@x - @op[:x])
        @angle ||= Math.atan((@z - @op[:z]) / (@x - @op[:x])) 
        @angle += rad_speed
        @angle = 0 if @angle > 20 * Math::PI #to prevent overflow

        @x = (Math.cos(@angle) * @r) + @op[:x]
        @z = (Math.sin(@angle) * @r) + @op[:z]
      }
    }
  end

  def initialize(init_x,init_y,init_z,speed,motion)
    @x = init_x
    @y = init_y
    @z = init_z
    @speed = speed
    @motion = motion
  end

  def do_motion
    @motion.call(self)
  end

  def draw
    do_motion
    pushMatrix
    translate(@x, @y, @z)
    fill($fill_color)
    box($obj_size)
    popMatrix
  end
end

def setup
  size 380, 380, P3D
  smooth
  frame_rate 30
  init_val
  noStroke
  $obj_stack = []
  $obj_stack << Obj.new(240,240,0,5,Obj::Motion::Zoom)
  $obj_stack << Obj.new(10,190,0,7,Obj::Motion::Circle)
  $obj_stack << Obj.new(10,180,0,4,Obj::Motion::Circle2)
end

def draw
  background($backcolor)
  lights
  $obj_stack.each do |o|
    o.draw
  end
end

def init_val
  $fill_color = rgb(255,0,0)
  $backcolor  = 0 #255
  $obj_size       = 10
end

def mouseClicked
  if key_pressed?
    puts key
    case key
    when 'a'
      $obj_stack << Obj.new(mouseX,mouseY,0,8,Obj::Motion::Circle)
    when 'b'
      $obj_stack << Obj.new(mouseX,mouseY,0,8,Obj::Motion::Circle2)
    end
    key = ''
  else
    $obj_stack << Obj.new(mouseX,mouseY,0,8,Obj::Motion::Zoom)
  end
end
