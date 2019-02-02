pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--init

function _init()
 
 players={}
 
 m=0
 
 add_player(0,16,16)
 add_player(1,32,32)
  
 han=0
 cooldown=0

end
-->8
--update

function _update()

	update_players()
 
 collide_players()
 
 if cooldown > 0 then
  cooldown-=1
 end
end
-->8
--draw

function _draw()
 cls(1)
 map(m*16)
 
 for p in all(players) do
 	spr(16+p.f,p.x,p.y)
 
	 if han==p.idx then
	  if cooldown==0 then
	   spr(4,p.x,p.y)
	  else
	   spr(5,p.x,p.y)
	  end
	 end
	end
end
-->8
--collisions

function c(v)
 return flr(v/8)
end

function collide(x,y,t)
 local a = collide_corner(x,y,t)
 local b = collide_corner(x+7,y,t)
 local c = collide_corner(x+7,y+7,t)
 local d = collide_corner(x,y+7,t)
 return a or b or c or d
end

function collide_corner(x,y,t)
 local a = c(x)+(m*16)
 local b = c(y)
  
 return fget(mget(a,b),t)
end

function collide_player(p1_x,p1_y,p2_x,p2_y)
 local a = p1_x+8>p2_x
 local b = p1_x<p2_x+8
	local c = p1_y+8>p2_y
 local d = p1_y<p2_y+8 
 return a and b and c and d
end

-->8
--players

function add_player(_idx,_x,_y)

	local p = {}
	
	p.idx=_idx
	p.x=_x
 p.y=_y
 p.vx=0
 p.vy=0
 p.bx=0
 p.by=0
 p.f=0
 
	add(players, p)
end

function update_players()
 for p in all(players) do
  p.f+=0.3
  if p.f>2 then
   p.f=0
  end
 
  local s=0.9
  local friction=0.7
 
  if btn(0,p.idx) then
   p.vx-=s
  end
  if btn(1,p.idx) then
   p.vx+=s
  end
  if btn(2,p.idx) then
   p.vy-=s
  end
  if btn(3,p.idx) then
   p.vy+=s
  end
   
  p.vx*=friction
  p.vy*=friction
 
  local cx=p.x+p.vx
  local cy=p.y+p.vy
 
  if collide(cx,p.y,0) then
  	p.vx=0
  else
  	p.x=cx
  end

	 if collide(p.x,cy,0) then
	  p.vy=0
	 else
 	 p.y=cy
  end 
 
  if collide(p.x,p.y,1) and han==0 then
  	m+=1
 	
 	 if m>2 then
 	  m=0
 	 end
 	
  end
 end
end

function collide_players()
 for p in all(players) do
  if p.idx==han then
   collide_han(p)
  end
 end
end

function collide_han(p1)
 for p2 in all(players) do
  
  if p1.idx!=p2.idx then
  	local collision = collide_player(p1.x,p1.y,p2.x,p2.y)
   local iscooling = cooldown != 0

   if collision and not iscooling then
    sfx(0)
    cooldown=30
    han=p2.idx
   end
  end
 end
end

__gfx__
00000000aaaaaaaa4444444477777777080000800c0000c000000000dddddddd0000000000000000000000000000000000000000000000000000000000000000
00000000a00ee00a455555547002200780000008c000000c000bb000d222222d0000000000000000000000000000000000000000000000000000000000000000
00700700a0eeee0a4555555470222207000000000000000000333300d222222d0000000000000000000000000000000000000000000000000000000000000000
00077000aeeeeeea455555547222222700000000000000000b3003b0d222222d0000000000000000000000000000000000000000000000000000000000000000
00077000aeeeeeea455555547222222700000000000000000b3003b0d222222d0000000000000000000000000000000000000000000000000000000000000000
00700700a0eeee0a4555555470222207000000000000000000333300d222222d0000000000000000000000000000000000000000000000000000000000000000
00000000a00ee00a455555547002200780000008c000000c000bb000d222222d0000000000000000000000000000000000000000000000000000000000000000
00000000aaaaaaaa4444444477777777080000800c0000c000000000dddddddd0000000000000000000000000000000000000000000000000000000000000000
000ccc00000ccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c6c00006c6c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00666660000066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006000000060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006000006660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00060600006060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00060600006006600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000010000000201000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0202020202020202020202020202020202020202020202020202020202020202070707070707070707070707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000202000006000000000000000000000002070600000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000202000000000000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000020202020200000202000000020202020202020000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200060000000000000000000000000202000000000002000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000202000000000000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000202000000000000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000202000000020000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000202000000020000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000200000000000000000202000000020000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000200000000000000000202000000020000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000200000000000000000202000000020202020200000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000202020202020000000202000000000000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000202000000000000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0200000000000000000000000000000202000000000000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202020202020202020202020202020202020202020202020202020202020202070707070707070707070707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000014010150101701018010190101b0101d0101f010210102301021010180101201000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
