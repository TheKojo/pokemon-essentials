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
	@customization_loc = "Graphics/Characters/Customization/"
  	@skin_name = "LIGHT"
	@hair_name = "EXPLORER"
	@hair_color_name = "BLONDE"
	@eye_name = "RED"
	@hat_name = "DESERTCAP"
	@shirt_name = "TRAINER"
	@glove_name = "TRAINER"
	@pants_name = "CARGO"
	@shoe_name = "BOOTS"
	@bag_name = "BASIC"
	@gender = $player.female? ? "Female/" : "Male/"
	@suffix = ""
	@walk_sheet = assembleTrainer
	@suffix = "run"
	@run_sheet = assembleTrainer
	echoln "Assembling trainer sprite..."
  end
  
  def assembleTrainer
	#Base Skin
	skin_bitmap = AnimatedBitmap.new(@customization_loc+@gender+"Skin/skin_"+@skin_name+@suffix, @character.character_hue)
	
	#Right Leg
	legr_bitmap = AnimatedBitmap.new(@customization_loc+@gender+"Skin/legr_"+@skin_name+@suffix, @character.character_hue)
	assemble(skin_bitmap,legr_bitmap)
	
	#Left Leg
	legl_bitmap = AnimatedBitmap.new(@customization_loc+@gender+"Skin/legl_"+@skin_name+@suffix, @character.character_hue)
	assemble(skin_bitmap,legl_bitmap)
	
	#Shoes
	shoer_bitmap  = AnimatedBitmap.new(@customization_loc+@gender+"Shoes/shoer_" +@shoe_name+@suffix, @character.character_hue)
	assemble(skin_bitmap,shoer_bitmap)
	shoel_bitmap  = AnimatedBitmap.new(@customization_loc+@gender+"Shoes/shoel_" +@shoe_name+@suffix, @character.character_hue)
	assemble(skin_bitmap,shoel_bitmap)
	
	#Pants
	pantsr_bitmap  = AnimatedBitmap.new(@customization_loc+@gender+"Pants/pantsr_" +@pants_name+@suffix, @character.character_hue)
	assemble(skin_bitmap,pantsr_bitmap)
	pantsl_bitmap  = AnimatedBitmap.new(@customization_loc+@gender+"Pants/pantsl_" +@pants_name+@suffix, @character.character_hue)
	assemble(skin_bitmap,pantsl_bitmap)
	
	#Shirt
	shirt_bitmap  = AnimatedBitmap.new(@customization_loc+@gender+"Shirt/shirt_" +@shirt_name+@suffix, @character.character_hue)
	assemble(skin_bitmap,shirt_bitmap)
	
	#Left Arm
	arml_bitmap = AnimatedBitmap.new(@customization_loc+@gender+"Skin/arml_"+@skin_name+@suffix, @character.character_hue)
	assemble(skin_bitmap,arml_bitmap)
	
	#Bag
	bag_bitmap  = AnimatedBitmap.new(@customization_loc+@gender+"Bag/bag_" +@bag_name+@suffix, @character.character_hue)
	assemble(skin_bitmap,bag_bitmap)
	
	#Right Arm
	armr_bitmap = AnimatedBitmap.new(@customization_loc+@gender+"Skin/armr_"+@skin_name+@suffix, @character.character_hue)
	assemble(skin_bitmap,armr_bitmap)
	
	#Sleeves
	shirtr_bitmap  = AnimatedBitmap.new(@customization_loc+@gender+"Shirt/shirtr_" +@shirt_name+@suffix, @character.character_hue)
	assemble(skin_bitmap,shirtr_bitmap)
	shirtl_bitmap  = AnimatedBitmap.new(@customization_loc+@gender+"Shirt/shirtl_" +@shirt_name+@suffix, @character.character_hue)
	assemble(skin_bitmap,shirtl_bitmap)
	
	#Right Glove
	glover_bitmap  = AnimatedBitmap.new(@customization_loc+@gender+"Gloves/glover_" +@glove_name+@suffix, @character.character_hue)
	assemble(skin_bitmap,glover_bitmap)
	
	#Left Glove
	glovel_bitmap  = AnimatedBitmap.new(@customization_loc+@gender+"Gloves/glovel_" +@glove_name+@suffix, @character.character_hue)
	assemble(skin_bitmap,glovel_bitmap)
	
	#Eye
	eye_bitmap  = AnimatedBitmap.new(@customization_loc+"Unisex/Eyes/eye_" +@eye_name+@suffix, @character.character_hue)
	assemble(skin_bitmap,eye_bitmap)
	
	#Hair
	hair_bitmap = AnimatedBitmap.new(@customization_loc+"Unisex/Hair/hair_"+@hair_name+"_"+@hair_color_name+@suffix, @character.character_hue)
	assemble(skin_bitmap,hair_bitmap)
	
	#Hat
	hats_bitmap  = AnimatedBitmap.new(@customization_loc+"Unisex/Hat/hats_" +@hat_name+@suffix, @character.character_hue)
	assemble(skin_bitmap,hats_bitmap,10)
	hat_bitmap  = AnimatedBitmap.new(@customization_loc+"Unisex/Hat/hat_" +@hat_name+@suffix, @character.character_hue)
	assemble(skin_bitmap,hat_bitmap)

	

	return skin_bitmap
  end
  
  #def assembleSkin

  #end
  
  def assemble(base, piece,opacity=255)
	base.bitmap.blt(0,0,piece.bitmap,Rect.new(0,0,piece.width,piece.height),opacity)
  end
  
  def assembleRight(base, piece)
	#
	base.bitmap.blt(0,0,piece.bitmap,Rect.new(0,0,piece.width,piece.height))
  end
  
  def assembleLeft(base, piece)
	base.bitmap.blt(0,0,piece.bitmap,Rect.new(0,0,piece.width,piece.height))
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
