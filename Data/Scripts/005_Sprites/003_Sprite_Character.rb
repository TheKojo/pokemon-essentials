#===============================================================================
#
#===============================================================================
class BushBitmap
  def initialize(bitmap, isTile, depth)
    @bitmaps  = []
    @bitmap   = bitmap
    @isTile   = isTile
    @isBitmap = @bitmap.is_a?(Bitmap)
    @depth    = depth
  end

  def dispose
    @bitmaps.each { |b| b&.dispose }
  end

  def bitmap
    thisBitmap = (@isBitmap) ? @bitmap : @bitmap.bitmap
    current = (@isBitmap) ? 0 : @bitmap.currentIndex
    if !@bitmaps[current]
      if @isTile
        @bitmaps[current] = pbBushDepthTile(thisBitmap, @depth)
      else
        @bitmaps[current] = pbBushDepthBitmap(thisBitmap, @depth)
      end
    end
    return @bitmaps[current]
  end

  def pbBushDepthBitmap(bitmap, depth)
    ret = Bitmap.new(bitmap.width, bitmap.height)
    charheight = ret.height / 4
    cy = charheight - depth - 2
    4.times do |i|
      y = i * charheight
      if cy >= 0
        ret.blt(0, y, bitmap, Rect.new(0, y, ret.width, cy))
        ret.blt(0, y + cy, bitmap, Rect.new(0, y + cy, ret.width, 2), 170)
      end
      ret.blt(0, y + cy + 2, bitmap, Rect.new(0, y + cy + 2, ret.width, 2), 85) if cy + 2 >= 0
    end
    return ret
  end

  def pbBushDepthTile(bitmap, depth)
    ret = Bitmap.new(bitmap.width, bitmap.height)
    charheight = ret.height
    cy = charheight - depth - 2
    y = charheight
    if cy >= 0
      ret.blt(0, y, bitmap, Rect.new(0, y, ret.width, cy))
      ret.blt(0, y + cy, bitmap, Rect.new(0, y + cy, ret.width, 2), 170)
    end
    ret.blt(0, y + cy + 2, bitmap, Rect.new(0, y + cy + 2, ret.width, 2), 85) if cy + 2 >= 0
    return ret
  end
end

#===============================================================================
#
#===============================================================================
class Sprite_Character < RPG::Sprite
  attr_accessor :character

  def initialize(viewport, character = nil)
    super(viewport)
    @character    = character
    @oldbushdepth = 0
    @spriteoffset = false
    if !character || character == $game_player || (character.name[/reflection/i] rescue false)
      @reflection = Sprite_Reflection.new(self, viewport)
    end
    @surfbase = Sprite_SurfBase.new(self, viewport) if character == $game_player
    self.zoom_x = TilemapRenderer::ZOOM_X
    self.zoom_y = TilemapRenderer::ZOOM_Y
	#CUSTOMIZATION
	buildTrainerSpriteSheets if character == $game_player
	#
    update
  end

  def buildTrainerSpriteSheets
    useFemale = $player.female?
    useFemale = true
	  @customization_loc = "Graphics/Characters/Customization/"
    @ride_loc = "Graphics/Characters/"
  	@skin_name = "LIGHT"
    @hair_name = useFemale ? "PONYTAIL": "EXPLORER"
    @hair_color_name = "BLONDE"
    @eye_name = useFemale ? "GREEN": "RED"
    @hat_name = useFemale ? "SUNHAT": "DESERTCAP"
    @shirt_name = "TRAINER"
    @glove_name = "TRAINER"
    @pants_name = "CARGO"
    @shoe_name = "BOOTS"
    @bag_name = "BASIC"
    @gender = useFemale ? "Female/" : "Male/"

    @ride_name = "OW_DOONGO"
    $PokemonGlobal.riding = true
    #$game_player.set_movement_type(:riding)

    @customization_bitmaps = {}
    #Initialize spritesheets for each part of the player
    for i in 0..1
      suffix = i == 1 ? "_run" : ""
      #Body Parts - Hair is optional
      #----------------------------------------
      #Torso,Head
      @customization_bitmaps["skin#{suffix}"] = AnimatedBitmap.new(@customization_loc+@gender+"Skin/skin_"+@skin_name+suffix, @character.character_hue)
      #Arms
      @customization_bitmaps["armr#{suffix}"] = AnimatedBitmap.new(@customization_loc+@gender+"Skin/armr_"+@skin_name+suffix, @character.character_hue)
      @customization_bitmaps["arml#{suffix}"] = AnimatedBitmap.new(@customization_loc+@gender+"Skin/arml_"+@skin_name+suffix, @character.character_hue)
      #Legs
      @customization_bitmaps["legr#{suffix}"] = AnimatedBitmap.new(@customization_loc+@gender+"Skin/legr_"+@skin_name+suffix, @character.character_hue)
      @customization_bitmaps["legl#{suffix}"] = AnimatedBitmap.new(@customization_loc+@gender+"Skin/legl_"+@skin_name+suffix, @character.character_hue)
      #Hair
      @customization_bitmaps["hair#{suffix}"] = AnimatedBitmap.new(@customization_loc+"Unisex/Hair/hair_"+@hair_name+"_"+@hair_color_name+suffix, @character.character_hue)
      #Eyes
      @customization_bitmaps["eye#{suffix}"]  = AnimatedBitmap.new(@customization_loc+"Unisex/Eyes/eye_" +@eye_name+suffix, @character.character_hue)

      #Clothing Parts - Shirt, Pants, Shoes, and Gloves are optional
      #----------------------------------------
      #Hat
      @customization_bitmaps["hat#{suffix}"]  = AnimatedBitmap.new(@customization_loc+"Unisex/Hat/hat_" +@hat_name+suffix, @character.character_hue)
      @customization_bitmaps["hats#{suffix}"] = AnimatedBitmap.new(@customization_loc+"Unisex/Hat/hats_" +@hat_name+suffix, @character.character_hue)
      #Shirt
      @customization_bitmaps["shirt#{suffix}"] = AnimatedBitmap.new(@customization_loc+@gender+"Shirt/shirt_" +@shirt_name+suffix, @character.character_hue)
      @customization_bitmaps["shirtr#{suffix}"] = AnimatedBitmap.new(@customization_loc+@gender+"Shirt/shirtr_" +@shirt_name+suffix, @character.character_hue)
      @customization_bitmaps["shirtl#{suffix}"] = AnimatedBitmap.new(@customization_loc+@gender+"Shirt/shirtl_" +@shirt_name+suffix, @character.character_hue)
      #Pants
      @customization_bitmaps["pantsr#{suffix}"] = AnimatedBitmap.new(@customization_loc+@gender+"Pants/pantsr_" +@pants_name+suffix, @character.character_hue)
      @customization_bitmaps["pantsl#{suffix}"] = AnimatedBitmap.new(@customization_loc+@gender+"Pants/pantsl_" +@pants_name+suffix, @character.character_hue)
      #Shoes
      @customization_bitmaps["shoer#{suffix}"] = AnimatedBitmap.new(@customization_loc+@gender+"Shoes/shoer_" +@shoe_name+suffix, @character.character_hue)
      @customization_bitmaps["shoel#{suffix}"] = AnimatedBitmap.new(@customization_loc+@gender+"Shoes/shoel_" +@shoe_name+suffix, @character.character_hue)
      #Gloves
      @customization_bitmaps["glover#{suffix}"] = AnimatedBitmap.new(@customization_loc+@gender+"Gloves/glover_" +@glove_name+suffix, @character.character_hue)
      @customization_bitmaps["glovel#{suffix}"] = AnimatedBitmap.new(@customization_loc+@gender+"Gloves/glovel_" +@glove_name+suffix, @character.character_hue)
      #Bag
      @customization_bitmaps["bag#{suffix}"] = AnimatedBitmap.new(@customization_loc+@gender+"Bag/bag_" +@bag_name+suffix, @character.character_hue)
    end

    #Order to layer the parts, from bottom to top
    @walkrun_layer_order = ["skin","legr","legl","shoer","shoel","pantsr","pantsl","shirt","arml","bag","armr","shirtr","shirtl","glover","glovel","eye","hair","hats","hat"]
    #@ride_layer_order

    echoln "Assembling trainer sprite..."
    @walk_sheet = assembleTrainer
    @run_sheet = assembleTrainer("_run")
    
  end
  
  def assembleTrainer(suffix="")
    character_bitmap = nil
    if $PokemonGlobal.riding
      character_bitmap = assembleRide
    else
      character_bitmap = assembleWalkRun(suffix)
    end
    return character_bitmap
  end



  def assembleWalkRun(suffix)
    player_bitmap = AnimatedBitmap.new(@customization_loc+"blank"+suffix, @character.character_hue)
    @walkrun_layer_order.each do |part|
      assemble(player_bitmap,@customization_bitmaps[part+suffix])
    end
    return player_bitmap
  end

  def assembleRide
    #Setup
    player_bitmap = AnimatedBitmap.new(@customization_loc+"blank_ride", @character.character_hue)
    ride_bitmap = AnimatedBitmap.new(@ride_loc.to_s+@ride_name.to_s, @character.character_hue)

    #Down movement
    @walkrun_layer_order.each do |part|
      assembleSingleFrame(player_bitmap,@customization_bitmaps[part+"_run"], 0, 0, 0, 0, 0, -12*2)
      assembleSingleFrame(player_bitmap,@customization_bitmaps[part+"_run"], 1, 0, 0, 0, 0, -12*2)
      assembleSingleFrame(player_bitmap,@customization_bitmaps[part+"_run"], 2, 0, 0, 0, 0, -12*2)
      assembleSingleFrame(player_bitmap,@customization_bitmaps[part+"_run"], 3, 0, 0, 0, 0, -12*2)
    end

    assembleSingleRow(player_bitmap, ride_bitmap, 0, 0, 0)

    #Left movement
    assembleRideLeftRight(player_bitmap, ride_bitmap, 1)

    #Right movement
    assembleRideLeftRight(player_bitmap, ride_bitmap, 2)

    #Up movement
    assembleSingleRow(player_bitmap, ride_bitmap, 3, 0, 0)

    @walkrun_layer_order.each do |part|
      xPos = 0
      yOffset = -6*2
      if (isLeg?(part) && !isFarPart?(part)) #Right Leg
        xPos = 1
        yOffset -= 2
      end
      if (isLeg?(part) && isFarPart?(part)) #Left Leg
        xPos = 3
        yOffset -= 2
      end
      assembleSingleFrame(player_bitmap,@customization_bitmaps[part+"_run"], 0, 3, xPos, 3, 0, yOffset)
      assembleSingleFrame(player_bitmap,@customization_bitmaps[part+"_run"], 1, 3, xPos, 3, 0, yOffset)
      assembleSingleFrame(player_bitmap,@customization_bitmaps[part+"_run"], 2, 3, xPos, 3, 0, yOffset)
      assembleSingleFrame(player_bitmap,@customization_bitmaps[part+"_run"], 3, 3, xPos, 3, 0, yOffset)
    end

    return player_bitmap
  end

  def assembleRideLeftRight(player_bitmap, ride_bitmap, direction) #1 = left, 2 = right
    assembleSingleRow(player_bitmap, ride_bitmap, direction, 0, 0)
    @walkrun_layer_order.each do |part|
      #Default to picking the part from the first frame of the run animation
      suffix = "_run"
      xPos = 0
      xOffset = 4*2
      yOffset = -9*2
      #Don't draw far parts
      if (isFarPart?(part))
        next
      end
      #Use the arm piece from the walking sheet instead
      if (isArm?(part))
        suffix = ""
        xPos = 1
        xOffset -= 4
        yOffset += 2
      end
      if (direction == 2)
        xOffset *= -1
      end
      assembleSingleFrame(player_bitmap,@customization_bitmaps[part+suffix], 0, direction, xPos, direction, xOffset, yOffset)
      assembleSingleFrame(player_bitmap,@customization_bitmaps[part+suffix], 1, direction, xPos, direction, xOffset, yOffset-2)
      assembleSingleFrame(player_bitmap,@customization_bitmaps[part+suffix], 2, direction, xPos, direction, xOffset, yOffset)
      assembleSingleFrame(player_bitmap,@customization_bitmaps[part+suffix], 3, direction, xPos, direction, xOffset, yOffset-2)
    end
  end


  def isFarPart?(part)
    #Left/Right movement frames have these parts in the background of the character and don't need to be drawn for ride animations. These have "l" appended at the end rather than "r"
    if (part == "arml" || part == "legl" || part == "shirtl" || part == "pantsl" || part == "glovel" || part == "shoel")
      return true
    else
      return false
    end
  end

  def isArm?(part)
    if (part == "armr" || part == "arml" || part == "shirtr" || part == "shirtl" || part == "glover" || part == "glovel" ) 
      return true
    else
      return false
    end
  end

  def isLeg?(part)
    if (part == "legr" || part == "legl" || part == "pantsr"  || part == "pantsl" || part == "shoer" || part == "shoel")
      return true
    else
      return false
    end
  end
  
  
  def assemble(base, piece, opacity=255)
	  base.bitmap.blt(0, 0, piece.bitmap, Rect.new(0, 0, piece.width, piece.height), opacity)
  end

  def assembleSingleFrame(base, piece, baseXPosition, baseYPosition, frameXPosition, frameYPosition, offsetX, offsetY, opacity=255)
    base.bitmap.blt(base.width/4*baseXPosition+offsetX, base.height/4*baseYPosition+offsetY, piece.bitmap, Rect.new(frameXPosition*piece.width/4, frameYPosition*piece.height/4, piece.width/4, piece.height/4), opacity)
  end

  def assembleSingleRow(base, piece, yPosition, offsetX, offsetY, opacity=255)
    assembleSingleFrame(base, piece, 0, yPosition, 0, yPosition, offsetX, offsetY, opacity)
    assembleSingleFrame(base, piece, 1, yPosition, 1, yPosition, offsetX, offsetY, opacity)
    assembleSingleFrame(base, piece, 2, yPosition, 2, yPosition, offsetX, offsetY, opacity)
    assembleSingleFrame(base, piece, 3, yPosition, 3, yPosition, offsetX, offsetY, opacity)
  end

  def groundY
    return @character.screen_y_ground
  end

  def visible=(value)
    super(value)
    @reflection.visible = value if @reflection
  end

  def dispose
    @bushbitmap&.dispose
    @bushbitmap = nil
    @charbitmap&.dispose
    @charbitmap = nil
    @reflection&.dispose
    @reflection = nil
    @surfbase&.dispose
    @surfbase = nil
    @character = nil
    super
  end

  def refresh_graphic
    return if @tile_id == @character.tile_id &&
              @character_name == @character.character_name &&
              @character_hue == @character.character_hue &&
              @oldbushdepth == @character.bush_depth
    @tile_id        = @character.tile_id
    @character_name = @character.character_name
    @character_hue  = @character.character_hue
    @oldbushdepth   = @character.bush_depth
    @charbitmap&.dispose
    @charbitmap = nil
    @bushbitmap&.dispose
    @bushbitmap = nil
    if @tile_id >= 384
      @charbitmap = pbGetTileBitmap(@character.map.tileset_name, @tile_id,
                                    @character_hue, @character.width, @character.height)
      @charbitmapAnimated = false
      @spriteoffset = false
      @cw = Game_Map::TILE_WIDTH * @character.width
      @ch = Game_Map::TILE_HEIGHT * @character.height
      self.src_rect.set(0, 0, @cw, @ch)
      self.ox = @cw / 2
      self.oy = @ch
    elsif @character_name != ""
		if (@walk_sheet.nil? || @run_sheet.nil?)
			buildTrainerSpriteSheets
		end
		
		#@charbitmap = nil
		if (@character == $game_player)
			echoln "char bitmap: "+@character_name
			if @character_name == "trrun000"
				@charbitmap = @run_sheet
			else
				@charbitmap = @walk_sheet
			end
			#@charbitmap = AnimatedBitmap.new("Graphics/Characters/Customization/Skin/skin_"+@skin_name, @character_hue)
		else
      @charbitmap = AnimatedBitmap.new(
        "Graphics/Characters/" + @character_name, @character_hue
      )
      RPG::Cache.retain("Graphics/Characters/", @character_name, @character_hue) if @character == $game_player
	end
      @charbitmapAnimated = true
      @spriteoffset = @character_name[/offset/i]
      @cw = @charbitmap.width / 4
      @ch = @charbitmap.height / 4
      self.ox = @cw / 2
    else
      self.bitmap = nil
      @cw = 0
      @ch = 0
    end
    @character.sprite_size = [@cw, @ch]
  end

  def update
    return if @character.is_a?(Game_Event) && !@character.should_update?
    super
    refresh_graphic
    return if !@charbitmap
    @charbitmap.update if @charbitmapAnimated
    bushdepth = @character.bush_depth
    if bushdepth == 0
      self.bitmap = (@charbitmapAnimated) ? @charbitmap.bitmap : @charbitmap
    else
      @bushbitmap = BushBitmap.new(@charbitmap, (@tile_id >= 384), bushdepth) if !@bushbitmap
      self.bitmap = @bushbitmap.bitmap
    end
    self.visible = !@character.transparent
    if @tile_id == 0
      sx = @character.pattern * @cw
      sy = ((@character.direction - 2) / 2) * @ch
      self.src_rect.set(sx, sy, @cw, @ch)
      self.oy = (@spriteoffset rescue false) ? @ch - 16 : @ch
      self.oy -= @character.bob_height
    end
    if self.visible
      if @character.is_a?(Game_Event) && @character.name[/regulartone/i]
        self.tone.set(0, 0, 0, 0)
      else
        pbDayNightTint(self)
      end
    end
    this_x = @character.screen_x
    this_x = ((this_x - (Graphics.width / 2)) * TilemapRenderer::ZOOM_X) + (Graphics.width / 2) if TilemapRenderer::ZOOM_X != 1
    self.x = this_x
    this_y = @character.screen_y
    this_y = ((this_y - (Graphics.height / 2)) * TilemapRenderer::ZOOM_Y) + (Graphics.height / 2) if TilemapRenderer::ZOOM_Y != 1
    self.y = this_y
    self.z = @character.screen_z(@ch)
    self.opacity = @character.opacity
    self.blend_type = @character.blend_type
    if @character.animation_id != 0
      animation = $data_animations[@character.animation_id]
      animation(animation, true)
      @character.animation_id = 0
    end
    @reflection&.update
    @surfbase&.update
  end
end
