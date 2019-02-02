pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
x=10
y=10

function _update()
 if btn(0) then
  x -= 1
  sfx(0)
 end
 if btn(1) then
  x += 1 
  sfx(0)
 end
 if btn(2) then
  y -= 1
  sfx(0)
 end
 if btn(3) then
  y += 1
  sfx(0)
 end
end

function _draw()
 cls()
 map(0,0)
 spr(7,x,y)
end
__gfx__
000000003333333333333333cccccccc4454454433333bb3333bb333000000000000000000000000000000000000000000000000000000000000000000000000
0000000033333333333333b3cccccccc445544443333bbbb338bb833040000000000000000000000000000000000000000000000000000000000000000000000
00700700333333333b3333b3cccccccc444444453333333333bbbb33040057000000000000000000000000000000000000000000000000000000000000000000
00077000333333333b333333cccccccc4544444533bbb33333b8bb330900999e0000000000000000000000000000000000000000000000000000000000000000
0007700033333333333b3333cccccccc454454443bbbbb3333344333099999000000000000000000000000000000000000000000000000000000000000000000
0070070033333333333b3333cccccccc444454443bbbbb3333344333044444000000000000000000000000000000000000000000000000000000000000000000
000000003333333333333333cccccccc545454543333333333344333090009000000000000000000000000000000000000000000000000000000000000000000
000000003333333333333333cccccccc444454543333333333333333090009000000000000000000000000000000000000000000000000000000000000000000
__map__
0101060601010103010104010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101060601010103010104010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101060602010103010404040404040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010103010401010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101050205010203030403030101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010401030101010600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0404040404040404040401030106010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101030101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101030101010600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
