$Bubble = 0

module BubbleConfig
  NONE = 0
  SCREAM = 1
  DEFAULT = 2
  YELLOW = 3
  INDIGO = 4
  ELEC = 5

  DEFAULT_WIDTH = 400
  DEFAULT_HEIGHT = 100

  BUBBLE_BITMAPS = ["Graphics/windowskins/frlgtextskin", RPG::Cache.picture("Arrow1"), RPG::Cache.picture("Arrow2"),
                    "Graphics/windowskins/scream", RPG::Cache.picture("Arrow3"), RPG::Cache.picture("Arrow3"),
                    "Graphics/windowskins/bubbleskin3", RPG::Cache.picture("Arrow1"), RPG::Cache.picture("Arrow2"),
                    "Graphics/windowskins/yellow", RPG::Cache.picture("ArrowYellow1"), RPG::Cache.picture("ArrowYellow2"),
                    "Graphics/windowskins/indigo", RPG::Cache.picture("ArrowIndigo1"), RPG::Cache.picture("ArrowIndigo2"),
                    "Graphics/windowskins/elec", RPG::Cache.picture("ArrowElec1"), RPG::Cache.picture("ArrowElec2")]

end

module MessageConfig
  BUBBLE_TEXT_MAIN_COLOR        = Color.new(22,22,22)
  BUBBLE_TEXT_SHADOW_COLOR      = Color.new(194,187,176) #Color.new(212,205,195) #194, 187, 176
  BUBBLE_TEXT_SHADOW_YELLOW     = Color.new(229,151,126)
  DARK_BUBBLE_TEXT_MAIN_COLOR   = Color.new(248,248,248)
  DARK_BUBBLE_TEXT_SHADOW_COLOR = Color.new(72,80,88)
  #Custom font choice from default Essentials
  FONT_NAME                = "Power Red and Green"
end

class ArrowSprite < RPG::Sprite
  attr_accessor :direction #2 = Arrow pointing down, 8 = Arrow pointing up
  attr_accessor :talking_event

  def initialize(viewport, talkingEvent)
    super(viewport)
    @direction = 2
    @talking_event = talkingEvent
  end

  def setArrowBitmap(bitmap, direction)
    @direction = direction
    self.bitmap = bitmap
    self.x = @talking_event.screen_x - @talking_event.sprite_size[1]/10 - 1*2
    self.z = 9999999
    case @direction
    when 2 then
      self.y = @talking_event.screen_y - @talking_event.sprite_size[0] - 5*2
    when 8 then
      self.y = @talking_event.screen_y
    end
  end
end

alias __kojo__pbCreateMessageWindow pbCreateMessageWindow unless defined?(__kojo__pbCreateMessageWindow)
def pbCreateMessageWindow(viewport = nil, skin = nil)
  if $Bubble != 0
		pbSetBubbleArrow(viewport, skin)
	end
  return __kojo__pbCreateMessageWindow(viewport, skin)
end

alias __kojo__pbDisposeMessageWindow pbDisposeMessageWindow unless defined?(__kojo__pbDisposeMessageWindow)
def pbDisposeMessageWindow(msgwindow)
  __kojo__pbDisposeMessageWindow(msgwindow)
  pbDisposeBubbleArrow
end

alias __kojo__pbRepositionMessageWindow pbRepositionMessageWindow unless defined?(__kojo__pbRepositionMessageWindow)
def pbRepositionMessageWindow(msgwindow, linecount = 2)
  __kojo__pbRepositionMessageWindow(msgwindow, linecount)
  if $game_system
    if $game_system.message_position == 2
      pbSetBubble(msgwindow, linecount)
    end
  end
end

alias __kojo__getSkinColor getSkinColor unless defined?(__kojo__getSkinColor)
def getSkinColor(windowskin, color, isDarkSkin)
  if !$Bubble || $Bubble == 0
    return __kojo__getSkinColor(windowskin, color, isDarkSkin)
  else
    textcolors = [
      MessageConfig::BUBBLE_TEXT_MAIN_COLOR,
      MessageConfig::BUBBLE_TEXT_SHADOW_COLOR,  # 1 Bubble default
      MessageConfig::DARK_BUBBLE_TEXT_MAIN_COLOR,
      MessageConfig::DARK_BUBBLE_TEXT_SHADOW_COLOR,  # 2 Dark Bubble default
      MessageConfig::BUBBLE_TEXT_SHADOW_COLOR,  
      MessageConfig::BUBBLE_TEXT_SHADOW_YELLOW  # 3 Yellow bubble
    ]
    if $Bubble==1 || $Bubble==2 || $Bubble==5
      color = 1
      isDarkSkin = false
    elsif $Bubble == 3
      color = 3
      isDarkSkin = false
    elsif $Bubble == 4
      color = 2
      isDarkSkin = false
    end
    # Special colour as listed above
    if isDarkSkin # Dark background, light text
      return shadowc3tag(textcolors[(2 * (color - 1)) + 1], textcolors[2 * (color - 1)])
    else
      # Light background, dark text
      return shadowc3tag(textcolors[2 * (color - 1)], textcolors[(2 * (color - 1)) + 1])
    end
  end
end

def pbCallBub(status=0, value=nil)
  $talkingEvent=get_character(value).id
  $Bubble=status
end

#Instantiate arrow bitmap and default positions
def pbSetBubbleArrow(viewport, skin)
  if $game_map
		interp = pbMapInterpreter
		thisEvent = interp.get_character(0)

    #Default position for most cases
    @arrow = ArrowSprite.new(@viewport, $game_map.events[$talkingEvent])
    @arrow.setArrowBitmap(BubbleConfig::BUBBLE_BITMAPS[$Bubble*3+1], 2)

    #Put bubble below if player is talking to NPC from above
    if $game_player.direction == 2 && @arrow.talking_event.direction == 8 && $game_player.y == @arrow.talking_event.y-1
      @arrow.setArrowBitmap(BubbleConfig::BUBBLE_BITMAPS[$Bubble*3+2], 8)
    end

	end
end

def pbSetBubble(msgwindow, linecount)
	if $Bubble >= 1
        interp = pbMapInterpreter
        thisEvent = interp.get_character(0)
        msgwindow.setSkin(BubbleConfig::BUBBLE_BITMAPS[$Bubble*3])
        msgwindow.width = BubbleConfig::DEFAULT_WIDTH
        msgwindow.height = BubbleConfig::DEFAULT_HEIGHT
        msgwindow.x = @arrow.x - msgwindow.width/2
        case @arrow.direction
        when 2 then
          msgwindow.y = @arrow.y - msgwindow.height + 2*2
        when 8 then 
          msgwindow.y = @arrow.y + @arrow.height - 2*2
        end
        
        #Reset
        $Bubble=0
        $talkingEvent=0
    else
        #Show regular text box, no speech bubble
        msgwindow.setSkin("Graphics/windowskins/choice 1")
        msgwindow.height = 102
        msgwindow.y = Graphics.height - msgwindow.height
    end
end

def pbDisposeBubbleArrow
  echoln "DISPOSING ARROW!"
	@arrow.dispose if @arrow
end
###

def oldJunkPositioning1
  if $game_map
		interp = pbMapInterpreter
		thisEvent = interp.get_character(0)
		if $game_player.direction==8
			@arrow = Sprite.new(@viewport)
			@arrow.bitmap = BubbleConfig::BUBBLE_BITMAPS[$Bubble*3+1]
			@arrow.x = $game_map.events[$talkingEvent].screen_x - 16
			@arrow.y = $game_map.events[$talkingEvent].screen_y - 60 + 10 - 20 #CHANGED 2017-04-30
			@arrow.z = 9999999
		else
			@arrow = Sprite.new(@viewport)
			@arrow.bitmap = BubbleConfig::BUBBLE_BITMAPS[$Bubble*3+2]
			@arrow.x = $game_map.events[$talkingEvent].screen_x - 16
			@arrow.y = $game_map.events[$talkingEvent].screen_y  - 6
			@arrow.z = 9999999
		end
  end
end


def oldJunkPositioning2
  if $game_player.direction==8
    msgwindow.y = $game_map.events[$talkingEvent].screen_y - 144 -20
    if msgwindow.x<0
      @NegativeValue = msgwindow.x
      msgwindow.x+=(-@NegativeValue)
    elsif msgwindow.x>88
      @OpposedValue = msgwindow.x-88
      msgwindow.x-=@OpposedValue
    end
    if msgwindow.y>282
      msgwindow.y = $game_map.events[$talkingEvent].screen_y - 144 -20
      @arrow.y = $game_map.events[$talkingEvent].screen_y - 60 + 10 -20
      @arrow.bitmap = BubbleConfig::BUBBLE_BITMAPS[$Bubble*3+1] #Point down

    elsif msgwindow.y<0
      msgwindow.y = $game_map.events[$talkingEvent].screen_y + @arrow.bitmap.height - 12 -20
      @arrow.y = $game_map.events[$talkingEvent].screen_y - 6 -20
      @arrow.bitmap = BubbleConfig::BUBBLE_BITMAPS[$Bubble*3+2] #Point up
    end
  else
    msgwindow.y = $game_map.events[$talkingEvent].screen_y + @arrow.bitmap.height - 12
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
      @arrow.y = $game_map.events[$talkingEvent].screen_y - 60 + 10
      @arrow.bitmap = BubbleConfig::BUBBLE_BITMAPS[$Bubble*3+1] #Point down
    elsif msgwindow.y<0
      msgwindow.y = $game_map.events[$talkingEvent].screen_y + @arrow.bitmap.height - 12
      @arrow.y = $game_map.events[$talkingEvent].screen_y  - 6
      @arrow.bitmap = BubbleConfig::BUBBLE_BITMAPS[$Bubble*3+2] #Point up
    end
  end
end