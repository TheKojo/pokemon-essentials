def pbCallBub(status=0, value=nil)
  $talkingEvent=get_character(value).id
  $Bubble=status
end

def pbSetBubbleArrow(viewport, skin)
    if $game_map
		arrowDown = "Arrow1"
		arrowUp = "Arrow2"
		if $Bubble == 1
			arrowDown = "Arrow3"
			arrowUp = "Arrow3"
		elsif $Bubble == 3
			arrowDown = "ArrowYellow1"
			arrowUp = "ArrowYellow2"
		elsif $Bubble == 4
			arrowDown = "ArrowIndigo1"
			arrowUp = "ArrowIndigo2"
		elsif $Bubble == 5
			arrowDown = "ArrowElec1"
			arrowUp = "ArrowElec2"
		end
		interp = pbMapInterpreter
		thisEvent = interp.get_character(0)
		if $game_player.direction==8
			@Arrow = Sprite.new(@viewport)
			@Arrow.bitmap = RPG::Cache.picture("Arrow1")
			@Arrow.x = $game_map.events[$talkingEvent].screen_x - 16
			@Arrow.y = $game_map.events[$talkingEvent].screen_y - 60 + 10 - 20 #CHANGED 2017-04-30
			@Arrow.z = 9999999
		else
			@Arrow = Sprite.new(@viewport)
			@Arrow.bitmap = RPG::Cache.picture("Arrow2")
			@Arrow.x = $game_map.events[$talkingEvent].screen_x - 16
			@Arrow.y = $game_map.events[$talkingEvent].screen_y  - 6
			@Arrow.z = 9999999
		end
	end
end

def pbSetBubble(msgwindow, linecount)
	if $Bubble==1 || $Bubble==2 || $Bubble==3 || $Bubble==4 || $Bubble==5
        interp = pbMapInterpreter
        thisEvent = interp.get_character(0)
        if $Bubble == 2
          msgwindow.setSkin("Graphics/windowskins/frlgtextskin")
        elsif $Bubble == 3
          msgwindow.setSkin("Graphics/windowskins/yellow")
        elsif $Bubble == 4
          msgwindow.setSkin("Graphics/windowskins/indigo")
        elsif $Bubble == 5
          msgwindow.setSkin("Graphics/windowskins/elec")
        else
          msgwindow.setSkin("Graphics/windowskins/scream")
        end
        msgwindow.width = 400
        msgwindow.height = 100
        msgwindow.x = $game_map.events[$talkingEvent].screen_x - (msgwindow.width/2)
        if $game_player.direction==8
          msgwindow.y = $game_map.events[$talkingEvent].screen_y - 144 -20 #CHANGED 2017-04-30
          if msgwindow.x<0
            @NegativeValue = msgwindow.x
            msgwindow.x+=(-@NegativeValue)
          elsif msgwindow.x>88
            @OpposedValue = msgwindow.x-88
            msgwindow.x-=@OpposedValue
          end
          if msgwindow.y>282
            msgwindow.y = $game_map.events[$talkingEvent].screen_y - 144 -20 #CHANGED 2017-04-30
            @Arrow.y = $game_map.events[$talkingEvent].screen_y - 60 + 10 -20 #CHANGED 2017-04-30
            if $Bubble==3
              @Arrow.bitmap = RPG::Cache.picture("ArrowYellow1")
            elsif $Bubble==4
              @Arrow.bitmap = RPG::Cache.picture("ArrowIndigo1")
            elsif $Bubble==5
              @Arrow.y -= 4
              @Arrow.bitmap = RPG::Cache.picture("ArrowElec1")
            else
              @Arrow.bitmap = RPG::Cache.picture("Arrow1")
            end
          elsif msgwindow.y<0
            msgwindow.y = $game_map.events[$talkingEvent].screen_y + @Arrow.bitmap.height - 12 -20 #CHANGED 2017-04-30
            @Arrow.y = $game_map.events[$talkingEvent].screen_y - 6 -20 #CHANGED 2017-04-30
            if $Bubble==3
              @Arrow.bitmap = RPG::Cache.picture("ArrowYellow2")
            elsif $Bubble==4
              @Arrow.bitmap = RPG::Cache.picture("ArrowIndigo2")
            elsif $Bubble==5
              @Arrow.bitmap = RPG::Cache.picture("ArrowElec2")
            else
              @Arrow.bitmap = RPG::Cache.picture("Arrow2")
            end
          end
        else
          msgwindow.y = $game_map.events[$talkingEvent].screen_y + @Arrow.bitmap.height - 12
          if msgwindow.x<0
            @NegativeValue = msgwindow.x
            msgwindow.x+=(-@NegativeValue)
          elsif msgwindow.x>88
            @OpposedValue = msgwindow.x-88
            msgwindow.x-=@OpposedValue
          end
		  msgwindow.x += 16
          if msgwindow.y>282
            msgwindow.y = $game_map.events[$talkingEvent].screen_y - 144
            @Arrow.y = $game_map.events[$talkingEvent].screen_y - 60 + 10
            if $Bubble==3
              @Arrow.bitmap = RPG::Cache.picture("ArrowYellow1")
            elsif $Bubble==4
              @Arrow.bitmap = RPG::Cache.picture("ArrowIndigo1")
            elsif $Bubble==5
              @Arrow.y -= 4
              @Arrow.bitmap = RPG::Cache.picture("ArrowElec1")
            else
              @Arrow.bitmap = RPG::Cache.picture("Arrow1")
            end
          elsif msgwindow.y<0
            msgwindow.y = $game_map.events[$talkingEvent].screen_y + @Arrow.bitmap.height - 12
            @Arrow.y = $game_map.events[$talkingEvent].screen_y  - 6
            if $Bubble==3
              @Arrow.bitmap = RPG::Cache.picture("ArrowYellow2")
            elsif $Bubble==4
              @Arrow.bitmap = RPG::Cache.picture("ArrowIndigo2")
            elsif $Bubble==5
              @Arrow.bitmap = RPG::Cache.picture("ArrowElec2")
            else
              @Arrow.bitmap = RPG::Cache.picture("Arrow2")
            end
          end
        end
        if $Bubble == 1
         @Arrow.bitmap = RPG::Cache.picture("Arrow3")
        end
        $Bubble=0
        $talkingEvent=0
    else
        msgwindow.setSkin("Graphics/windowskins/choice 1")
        msgwindow.height = 102
        msgwindow.y = Graphics.height - msgwindow.height
    end
end

def pbDisposeBubbleArrow
	@Arrow.dispose if @Arrow
end
###