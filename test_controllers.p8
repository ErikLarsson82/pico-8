pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
function _draw()
  cls()
  for p=0,8 do
    print(''..p..':', 0, p*7, 1)
    for b=0,6 do
      if btn(b,p) then
        print(b, b*5 + 10, p*7, p+1)
      end
    end
  end
end

