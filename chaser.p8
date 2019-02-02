pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--init

function _init()
	seqinit()
end

han=0

pinputs={
	[0]=1,
	1,
}

function seqinit()
	_update=sequpdate
	_draw=seqdraw
	
	seqdone=false
	blinktimer=0
	
	sequence={
		flr(rnd(5)),
		flr(rnd(5)),
		flr(rnd(5)),
		flr(rnd(5)),
		flr(rnd(5)),
		flr(rnd(5)),
		flr(rnd(5)),
	}
end

function kullinit()
	_update=kullupdate
	_draw=kulldraw
 
 players={}
 
 m=0
 
 t_timer=0
 
 add_player(0,16,16)
 add_player(1,110,110)
  
 add_boost()
 add_boost()
 add_boost()
 add_boost()
 
 add_brick()

 cooldown=0
 
 arrow_timer=0
 
 game_over=false

end

-->8
--update

function sequpdate()
	
	if seqdone then
		if blinktimer > 40 then
			kullinit()
		else
			blinktimer+=1
		end
		return
	end

	for i=0,#pinputs do
		local nextinput=pinputs[i]
		for b=0,5 do
			if btnp(b,i) then
			 if sequence[nextinput] == b then
			 	pinputs[i]+=1
			 	if pinputs[i] > #sequence then
			 		han=i+1
			 		if han > 1 then
			 			han=0
			 		end
			 		seqdone=true
			 		sfx(2)
			 		return
			 	end
			 else
			 	pinputs[i]=1
			 	sfx(3)
			 end
			end
		end
	end
end

function kullupdate()

 if game_over then
  return
 end
 
 for p in all(players) do
  if p.score<=0 then
   game_over=true
  end
 end
 
	update_players()
 
 collide_players()
 
 tile_timer()
 
 if players[1].score==players[2].score then
  sfx(1)
  arrow_timer=20
 end
 
 if arrow_timer>0 then
  arrow_timer-=1
 end
 
 if cooldown > 0 then
  cooldown-=1
 end
end
-->8
--draw

glyphs={
[0]="\x8b",
"\x91",
"\x94",
"\x83",
"\x8e",
}

function seqdraw()
	cls(3)
	
	s=""
	for press in all(sequence) do
		s=s..glyphs[press]
	end
	color(6)
	print(s,20,30)
	print(s,20,60)
	
	for p=0,#pinputs do
		s=""
 	for i=1,pinputs[p]-1 do
 		local press=sequence[i]
 		s=s..glyphs[press]
 	end
 	
 	color(11)
 	if pinputs[p]-1 == #sequence and
 				blinktimer % 4 < 2 then
 		color(10)
 	end
 	print(s,20,30+30*p)
 end
end


function kulldraw()
 cls(1)
 map(m*16)
 
 rectfill(0,0,128,7,3)
 
 for p in all(players) do
 	local fliph=p.vx>0
 	spr(16+(p.idx*2)+p.f,p.x,p.y,1,1,fliph)
 
	 if han==p.idx then
	  if cooldown==0 then
	   spr(4,p.x,p.y)
	  else
	   spr(5,p.x,p.y)
	  end
	 end
	 
	 print(tostr(p.hasbrick).." "..p.score,
	 		1+p.idx*86,
	 		1,
	 		7)
	end
	
	local arrow="<--"
	color(6)
	
	if arrow_timer>0 then
	 rectfill(54,0,68,7,11)
	 color(10)
	end
	
	if players[1].score < players[2].score then
	 arrow="-->"
	end
	
	print(arrow,56,1)
	
	if game_over then
	 rectfill(0,60,128,68,9)
	 print("game over",46,62,10)
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
 p.score=1000
 p.boost_timer=0
 p.hasbrick=false
 
	add(players, p)
end

function update_players()
 for p in all(players) do
  
  local is_han=p.idx==han
  
  if is_han then
   p.score-=1
  end
  
  local cooldown_factor=1
  if is_han and cooldown>0 then
   cooldown_factor=0.1
  end
  
  local s=0.75
  if p.boost_timer > 0 then
  	s=2
  	p.boost_timer-=1
  end
  if is_han then
  	s=1
  end

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
  
  if p.hasbrick and
     btnp(4,p.idx) then
  	mset(c(p.x+4),c(p.y+4),2)
  	p.hasbrick=false
  end
   
  p.vx*=friction
  p.vy*=friction
 
  local cx=p.x+p.vx*cooldown_factor
  local cy=p.y+p.vy*cooldown_factor
 
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
  
  -- keep inside screen
  p.x=mid(0,p.x,127-7)
  p.y=mid(7,p.y,127-7)
  
  local anim=(abs(p.vx)+abs(p.vy))/2
  p.f+=mid(0,anim,1)
  if p.f>=2 then
   p.f=0
  end
 
  
  -- test against boosts
  if not is_han and
  		 collide(p.x,p.y,3) then
  	p.boost_timer=15
  	if fget(mget(c(p.x),c(p.y)),3) then
  		mset(c(p.x),c(p.y),0)
  		add_boost()
  	end
  	if fget(mget(c(p.x+7),c(p.y)),3) then
  		mset(c(p.x+7),c(p.y),0)
  		add_boost()
  	end
  	if fget(mget(c(p.x),c(p.y+7)),3) then
  		mset(c(p.x),c(p.y+7),0)
  		add_boost()
  	end
  	if fget(mget(c(p.x+7),c(p.y+7)),3) then
  		mset(c(p.x+7),c(p.y+7),0)
  		add_boost()
  	end
  end
  
  -- test against boosts
  if p.hasbrick != true and
  			collide(p.x,p.y,4) then
  	p.hasbrick=true
  	if fget(mget(c(p.x),c(p.y)),4) then
  		mset(c(p.x),c(p.y),0)
  		add_brick()
  	end
  	if fget(mget(c(p.x+7),c(p.y)),4) then
  		mset(c(p.x+7),c(p.y),0)
  		add_brick()
  	end
  	if fget(mget(c(p.x),c(p.y+7)),4) then
  		mset(c(p.x),c(p.y+7),0)
  		add_brick()
  	end
  	if fget(mget(c(p.x+7),c(p.y+7)),4) then
  		mset(c(p.x+7),c(p.y+7),0)
  		add_brick()
  	end
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
  if collide(p.x,p.y,0) then
   local mx=p.x+4
   local my=p.y+4
   
   local tx=p.x+4-((p.x+4)%8)+4
   local ty=p.y+4-((p.y+4)%8)+4
   
   local vx=mx-tx
   local vy=my-ty
   
   local a=atan2(vx,vy)
   
   p.x+=cos(a)*11.5
   p.y+=sin(a)*11.5
  end
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
    cooldown=45
    han=p2.idx
    p1.boost_timer=45
   end
  end
 end
end

-->8
--tile_timer

function tile_timer()
 t_timer+=1
 local t=100
 
 if t_timer==t/2 then
  for tx=0,15 do
   for ty=0,15 do
  	 if fget(mget(tx,ty),2) then
  	 	mset(tx,ty,9)
  	 end
  	end
  end
 end
 if t_timer==t then
  t_timer=0
  for tx=0,15 do
   for ty=0,15 do
  	 if fget(mget(tx,ty),2) then
  		 mset(tx,ty,8)
  	 end
  	end
  end
 end
end
-->8
-- power-ups

function add_boost()
	local x=0
	local y=0
	
	repeat
	 x=rnd(15)
	 y=rnd(14)+1
	until not (
								collide(x*8,y*8,0) or
								collide(x*8,y*8,1) or
								collide(x*8,y*8,2) or
								collide(x*8,y*8,3) or
								collide(x*8,y*8,4))
	mset(x,y,10)
end

function add_brick()
	local x=0
	local y=0
	
	repeat
	 x=rnd(15)
	 y=rnd(14)+1
	until not (
								collide(x*8,y*8,0) or
								collide(x*8,y*8,1) or
								collide(x*8,y*8,2) or
								collide(x*8,y*8,3) or
								collide(x*8,y*8,4))
	mset(x,y,11)
end

__gfx__
00000000aaaaaaaa44444444777777770c0000c00800008000000000dddddddd0505050544444444000000000000000000000000000000000000000000000000
00000000a00ee00a4555555470022007c000000c80000008000bb000d222222d50505050455dd554000000000004444400000000000000000000000000000000
00700700a0eeee0a4555555470222207000000000000000000333300d222222d0505050545d55d5400a00a000045554200000000000000000000000000000000
00077000aeeeeeea455555547222222700000000000000000b3003b0d222222d505050504d5555d4000aa0000455541200000000000000000000000000000000
00077000aeeeeeea455555547222222700000000000000000b3003b0d222222d050505054d5555d4000aa0004444412000000000000000000000000000000000
00700700a0eeee0a4555555470222207000000000000000000333300d222222d5050505045d55d5400a00a002111220000000000000000000000000000000000
00000000a00ee00a4555555470022007c000000c80000008000bb000d222222d05050505455dd554000000002222200000000000000000000000000000000000
00000000aaaaaaaa44444444777777770c0000c00800008000000000dddddddd5050505044444444000000000000000000000000000000000000000000000000
000ccc00000ccc000004440000044400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c6c00006c6c000004b40000b4b400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006000000660000000b000000bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
006666600000660000bbbbb00000bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006000000060600000b0000000b0b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006000006660000000b00000bbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0006060000606000000b0b0000b0b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0006060000600660000b0b0000b00bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000010000000201040508100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000002020202020202020202020202020202070707070707070707070707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000080000000000000002000006000000000000000000000002070600000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000080000000000000002000000000000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000020202020200000002000000020202020202020000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000002000000000002000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000002000000000000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000002000000000000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000002000000020000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000080808080802000000020000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0808080808080200000000080000000002000000020000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000200000000080000000002000000020000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000200000000080000000002000000020202020200000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000202020202020000000002000000000000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000002000000000000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000002000000000000000000000000000002070000000000000000000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000002020202020202020202020202020202070707070707070707070707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000014010150101701018010190101b0101d0101f010210102301021010180101201000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00040000110100f0100f01011010160101b0102201029010270500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0005000027310273102231024310273102b310243101f3101d3101f31027310293102e310223101f310273102b3102e3102e3103031035310373203a3203a320163001630018300183001b3001d3001f30000300
00020000000000f5200f5200c5200c5200a5200a52007520055200352003520035200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
