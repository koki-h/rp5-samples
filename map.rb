# Map
# wikipedia にあった日本地図の塗り分けプログラムをruby-processingに移植してみた。
# http://ja.wikipedia.org/wiki/Processing#.E6.97.A5.E6.9C.AC.E5.9C.B0.E5.9B.B3.E3.81.AE.E5.A1.97.E3.82.8A.E5.88.86.E3.81.91

class Map < Processing::App
  @@map_scale = 0.25;
  @@square_len = 512;
  Prefectures  = [1,3,5,7,11,13,17,19,23,29,31,37,41,43];  # Prime numbers


  def setup
    @japan = loadShape("http://upload.wikimedia.org/wikipedia/commons/5/56/Blank_map_of_Japan.svg");
    size(@@square_len,@@square_len);
    smooth();
    noLoop();
  end

  def draw
    background(color(0, 0, 255));  # blue
    @japan.disableStyle();
    @japan.getChild("ground").getChild(0).scale(@@map_scale);
    fill(color(255, 255, 0));  # yellow
    shape(@japan.getChild("ground").getChild(0), @@square_len * @@map_scale, @@square_len * @@map_scale);
    prefecturesColoring(@japan ,Prefectures , color(255, 0, 255), @@map_scale);  # magenta
    saveFrame("output.png");
  end

  def prefecturesColoring(nation, prefectures, c, n)
    prefectures.each do |p|
      prefecture = nation.getChild("ground").getChild(0).getChild(p);
      prefecture.disableStyle();  # Disable the colors found in the SVG file
      prefecture.scale(n);
      fill(c);  # Set our own coloring
      noStroke();
      shape(prefecture, @@square_len * @@map_scale, @@square_len * @@map_scale);  # Draw a single prefecture
    end
  end


end

Map.new :title => "Map"
