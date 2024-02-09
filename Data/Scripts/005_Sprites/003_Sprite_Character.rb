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

  def replaceColor(bitmap, oldColor, newColor)
    bitmap.height.times do |y|
      bitmap.width.times do |x|
        color = bitmap.get_pixel(x, y)
        if color.red == oldColor.red && color.green == oldColor.green && color.blue == oldColor.blue
          bitmap.set_pixel(x, y, newColor)
        end
      end
    end  
  end

  def setSkinColor(skinBitmap, val)
    replaceColor(skinBitmap, @defaultSkinColor[0], @skinColors[val][0]);
    replaceColor(skinBitmap, @defaultSkinColor[1], @skinColors[val][1]);
    replaceColor(skinBitmap, @defaultSkinColor[2], @skinColors[val][2]);
    replaceColor(skinBitmap, @defaultSkinColor[3], @skinColors[val][3]);
  end

  def buildTrainerSpriteSheets
    @defaultSkinColor = [Color.new(248, 220, 204), Color.new(248,208,184), Color.new(215,161,149), Color.new(137,80,47)]
    @skinColors = [
      [Color.new(169, 114, 84), Color.new(148,93,66), Color.new(108,61,42), Color.new(72,40,16)]
    ]

    useFemale = $player.female?
    useFemale = false
    drawBag = false
    preset = 3
	  @customization_loc = "Graphics/Characters/Customization/"
    @ride_loc = "Graphics/Characters/"
    @ride_name = "OW_DOONGO"
    $PokemonGlobal.riding = false
    if preset == 0
      useFemale = false
      @skin_name = "2"
      @hair_name = useFemale ? "PONYTAIL": "EXPLORER"
      @hair_color_name = "BLONDE"
      @eye_name = useFemale ? "GREEN": "RED"
      @hat_name = useFemale ? "SUNHAT": "DESERTCAP"
      @shirt_name = "TRAINER"
      @glove_name = "TRAINER"
      @pants_name = "CARGO"
      @shoe_name = "BOOTS"
      @bag_name = drawBag ? "BASIC" : "NONE"
      @gender = useFemale ? "Female/" : "Male/"
    end
    if preset == 1
      useFemale = true
      @skin_name = "2"
      @hair_name = useFemale ? "PONYTAIL": "EXPLORER"
      @hair_color_name = "BLONDE"
      @eye_name = useFemale ? "GREEN": "RED"
      @hat_name = useFemale ? "SUNHAT": "DESERTCAP"
      @shirt_name = "TRAINER"
      @glove_name = "TRAINER"
      @pants_name = "CARGO"
      @shoe_name = "BOOTS"
      @bag_name = drawBag ? "BASIC" : "NONE"
      @gender = useFemale ? "Female/" : "Male/"
      $PokemonGlobal.riding = true
    end
    if preset == 2
      useFemale = false
      @skin_name = "8"
      @hair_name = "DREADS"
      @hair_color_name = "COBALT"
      @eye_name = "BLUE"
      @hat_name = "HEADBAND"
      @shirt_name = "OVERALLS"
      @glove_name = "TRAINER_PINK"
      @pants_name = "OVERALLS"
      @shoe_name = "SNEAKER"
      @bag_name = drawBag ? "BASIC" : "NONE"
      @gender = useFemale ? "Female/" : "Male/"
    end
    if preset == 3
      useFemale = true
      @skin_name = "6"
      @hair_name = "PRINCESS"
      @hair_color_name = "MAROON"
      @eye_name = "PURERED"
      @hat_name = "BANDANA"
      @shirt_name = "CROPWHITE"
      @glove_name = "KNUCKLER"
      @pants_name = "JEANSHORT"
      @shoe_name = "STRIPEDSTOCKING"
      @bag_name = drawBag ? "BASIC" : "NONE"
      @gender = useFemale ? "Female/" : "Male/"
    end


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
      @customization_bitmaps["faceshadow#{suffix}"] = AnimatedBitmap.new(@customization_loc+"Unisex/Skin/faceshadow_" +@skin_name+suffix, @character.character_hue)
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
      
      #setSkinColor(@customization_bitmaps["skin#{suffix}"].bitmap, 0)
      #setSkinColor(@customization_bitmaps["armr#{suffix}"].bitmap, 0)
      #setSkinColor(@customization_bitmaps["arml#{suffix}"].bitmap, 0)
      #setSkinColor(@customization_bitmaps["legr#{suffix}"].bitmap, 0)
      #setSkinColor(@customization_bitmaps["legl#{suffix}"].bitmap, 0)
    end

    #Order to layer the parts, from bottom to top
    @walkrun_layer_order = ["skin","legr","legl","shoer","shoel","pantsr","pantsl","shirt","arml","bag","armr","shirtr","shirtl","glover","glovel","eye","faceshadow","hair","hat"]
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
    ride_bitmap = AnimatedBitmap.new(@ride_loc.to_s+@ride_name.to_s, @character.character_hue)
    player_bitmap = AnimatedBitmap.new(@customization_loc+"blank_ride", @character.character_hue)
    
    playerSize = 200
    rideBitmapSize = ride_bitmap.width/2
    adjustmentNeededPerFrame = (rideBitmapSize - playerSize)/4
    sizeAdjustX = adjustmentNeededPerFrame/2
    sizeAdjustY = adjustmentNeededPerFrame
    sizeAdjustX *= 2 #Resolution adjustment
    sizeAdjustY *= 2 #Resolution adjustment

    echoln "adjustmentNeededPerFrame" + adjustmentNeededPerFrame.to_s

    #Down movement---------------------------------
    #Assemble player layers first if player needs to appear behind the ride sprite
    @walkrun_layer_order.each do |part|
      assembleSingleFrame(player_bitmap,@customization_bitmaps[part+"_run"], 0, 0, 0, 0, sizeAdjustX, -12*2+sizeAdjustY)
      assembleSingleFrame(player_bitmap,@customization_bitmaps[part+"_run"], 1, 0, 0, 0, sizeAdjustX, -12*2+2+sizeAdjustY)
      assembleSingleFrame(player_bitmap,@customization_bitmaps[part+"_run"], 2, 0, 0, 0, sizeAdjustX, -12*2+sizeAdjustY)
      assembleSingleFrame(player_bitmap,@customization_bitmaps[part+"_run"], 3, 0, 0, 0, sizeAdjustX, -12*2+2+sizeAdjustY)
    end
    #Put ride sprite on top layer of bitmap 
    assembleSingleRow(player_bitmap, ride_bitmap, 0, 0, 0)

    #Left movement---------------------------------
    assembleRideLeftRight(player_bitmap, ride_bitmap, 1, sizeAdjustX, sizeAdjustY)

    #Right movement--------------------------------
    assembleRideLeftRight(player_bitmap, ride_bitmap, 2, sizeAdjustX, sizeAdjustY)

    #Up movement-----------------------------------
    #Start by putting ride sprite on the bottom layer of the bitmap
    assembleSingleRow(player_bitmap, ride_bitmap, 3, 0, 0)

    #Iterate through player parts and layer onto bitmap
    @walkrun_layer_order.each do |part|
      xPos = 0
      yOffset = -6*2
      if (isLeg?(part) && !isFarPart?(part)) #Right Leg
        xPos = 1
        yOffset -= 4
      end
      if (isLeg?(part) && isFarPart?(part)) #Left Leg
        xPos = 3
        yOffset -= 4
      end

      for i in 0..3
        bob = 0
        if (i % 2 != 0)
          bob = -2
        end
        #For head only take all frames rather than just first
        if (isHead?(part))
          xPos = i
          if (i % 2 != 0)
            bob -= 2*2 #Readjustment since every other frame moves head parts up by 2 pixels
          end
        end
        assembleSingleFrame(player_bitmap,@customization_bitmaps[part+"_run"], i, 3, xPos, 3, sizeAdjustX, yOffset+bob+sizeAdjustY)
      end

      #assembleSingleFrame(player_bitmap,@customization_bitmaps[part+"_run"], 0, 3, xPos, 3, 0, yOffset)
      #assembleSingleFrame(player_bitmap,@customization_bitmaps[part+"_run"], 1, 3, xPos, 3, 0, yOffset-2)
      #assembleSingleFrame(player_bitmap,@customization_bitmaps[part+"_run"], 2, 3, xPos, 3, 0, yOffset)
      #assembleSingleFrame(player_bitmap,@customization_bitmaps[part+"_run"], 3, 3, xPos, 3, 0, yOffset-2)
    end

    return player_bitmap
  end

  def assembleRideLeftRight(player_bitmap, ride_bitmap, direction, sizeAdjustX, sizeAdjustY) #1 = left, 2 = right
    #Start by putting ride sprite on the bottom layer of the bitmap
    assembleSingleRow(player_bitmap, ride_bitmap, direction, 0, 0)

    #Iterate through player parts and layer onto bitmap
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
        yOffset += 4
      end
      if (direction == 2)
        xOffset *= -1
      end
      for i in 0..3
        bob = 0
        if (i % 2 != 0)
          bob = -2
        end
        #For head only take all frames rather than just first
        if (isHead?(part))
          xPos = i
          if (i % 2 != 0)
            bob += 2*2 #Readjustment since every other frame moves head parts up by 2 pixels
          end
        end
        assembleSingleFrame(player_bitmap,@customization_bitmaps[part+suffix], i, direction, xPos, direction, xOffset+sizeAdjustX, yOffset+bob+sizeAdjustY)
      end
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

  def isHead?(part)
    if (part == "hair" || part == "hat" || part == "faceshadow" || part == "eye" || part == "eyewear") 
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
    echoln "disposing"
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
    echoln "refreshing " + @character_name + " game player is "+(@character == $game_player).to_s
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
      if (@character == $game_player && (@walk_sheet.nil? || @run_sheet.nil?))
        buildTrainerSpriteSheets if @character == $game_player
      end
      
      #@charbitmap = nil
      if (@character == $game_player)
        if @character_name == "trrun000"
          @charbitmap = @run_sheet.copy
        else
          @charbitmap = @walk_sheet.copy
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
