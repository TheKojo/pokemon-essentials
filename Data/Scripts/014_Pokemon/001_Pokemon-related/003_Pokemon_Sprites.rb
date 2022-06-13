#===============================================================================
# Pokémon sprite (used out of battle)
#===============================================================================
class PokemonSprite < SpriteWrapper
  def initialize(viewport = nil)
    super(viewport)
    @_iconbitmap = nil
  end

  def dispose
    @_iconbitmap&.dispose
    @_iconbitmap = nil
    self.bitmap = nil if !self.disposed?
    super
  end

  def clearBitmap
    @_iconbitmap&.dispose
    @_iconbitmap = nil
    self.bitmap = nil
  end

  def setOffset(offset = PictureOrigin::CENTER)
    @offset = offset
    changeOrigin
  end

  def changeOrigin
    return if !self.bitmap
    @offset = PictureOrigin::CENTER if !@offset
    case @offset
    when PictureOrigin::TOP_LEFT, PictureOrigin::LEFT, PictureOrigin::BOTTOM_LEFT
      self.ox = 0
    when PictureOrigin::TOP, PictureOrigin::CENTER, PictureOrigin::BOTTOM
      self.ox = self.bitmap.width / 2
    when PictureOrigin::TOP_RIGHT, PictureOrigin::RIGHT, PictureOrigin::BOTTOM_RIGHT
      self.ox = self.bitmap.width
    end
    case @offset
    when PictureOrigin::TOP_LEFT, PictureOrigin::TOP, PictureOrigin::TOP_RIGHT
      self.oy = 0
    when PictureOrigin::LEFT, PictureOrigin::CENTER, PictureOrigin::RIGHT
      self.oy = self.bitmap.height / 2
    when PictureOrigin::BOTTOM_LEFT, PictureOrigin::BOTTOM, PictureOrigin::BOTTOM_RIGHT
      self.oy = self.bitmap.height
    end
  end

  def setPokemonBitmap(pokemon, back = false)
    @_iconbitmap&.dispose
    @_iconbitmap = (pokemon) ? GameData::Species.sprite_bitmap_from_pokemon(pokemon, back) : nil
    self.bitmap = (@_iconbitmap) ? @_iconbitmap.bitmap : nil
    self.color = Color.new(0, 0, 0, 0)
    changeOrigin
  end

  def setPokemonBitmapSpecies(pokemon, species, back = false)
    @_iconbitmap&.dispose
    @_iconbitmap = (pokemon) ? GameData::Species.sprite_bitmap_from_pokemon(pokemon, back, species) : nil
    self.bitmap = (@_iconbitmap) ? @_iconbitmap.bitmap : nil
    changeOrigin
  end

  def setSpeciesBitmap(species, gender = 0, form = 0, shiny = false, shadow = false, back = false, egg = false)
    @_iconbitmap&.dispose
    @_iconbitmap = GameData::Species.sprite_bitmap(species, form, gender, shiny, shadow, back, egg)
    self.bitmap = (@_iconbitmap) ? @_iconbitmap.bitmap : nil
    changeOrigin
  end

  def update
    super
    if @_iconbitmap
      @_iconbitmap.update
      self.bitmap = @_iconbitmap.bitmap
    end
  end
end



#===============================================================================
# Pokémon icon (for defined Pokémon)
#===============================================================================
class PokemonIconSprite < SpriteWrapper
  attr_accessor :selected
  attr_accessor :active
  attr_accessor :animating
  attr_reader   :pokemon

  def initialize(pokemon,viewport=nil)
    super(viewport)
    @animBitmap=nil
    @frames=[
       Rect.new(0,0,64,64),
       Rect.new(64,0,64,64),#Rect.new(64,0,64,64) CHANGED
       Rect.new(128,0,64,64),
       Rect.new(192,0,64,64)
    ]
    @selected     = false
    @animframe=0
    @active       = false
	@frame=0
    @numFrames    = 0
    @currentFrame = 0
    @counter      = 0
    self.pokemon  = pokemon
    @pokemon=pokemon
    @logical_x    = 0   # Actual x coordinate
    @logical_y    = 0   # Actual y coordinate
    @animating=true
    @adjusted_x   = 0   # Offset due to "jumping" animation in party screen
    @adjusted_y   = 0   # Offset due to "jumping" animation in party screen
  end

  def dispose
    @animBitmap&.dispose
    super
  end

  def x; return @logical_x; end
  def y; return @logical_y; end

  def x=(value)
    @logical_x = value
    super(@logical_x + @adjusted_x)
  end

  def y=(value)
    @logical_y = value
    super(@logical_y + @adjusted_y)
  end

  def update
    @updating=true
    super
    if @animBitmap
      @animBitmap.update
      self.bitmap=@animBitmap.bitmap 
      self.src_rect=@frames[@animframe]
    end
    self.color=Color.new(0,0,0,0)
    frameskip=24
    frameskip=48 if @pokemon && @pokemon.hp<=(@pokemon.totalhp/2)
    frameskip=96 if @pokemon && @pokemon.hp<=(@pokemon.totalhp/4)
    frameskip=-1 if @pokemon && (@pokemon.hp==0 || @animating == false)
    if frameskip == -1
      @animframe=0
      self.src_rect=@frames[@animframe]
    else
      @frame+=1
      if @frame % frameskip == 0
        self.src_rect=@frames[@animframe]
        @animframe += 1
        if @animframe == 4
          @animframe = 0
		  @frame = 0
        end
      end
    end
    @updating=false
    self.x=self.x
    self.y=self.y
  end
  
  def pokemon=(value)
    @pokemon = value
    @animBitmap&.dispose
    @animBitmap = nil
    if !@pokemon
      self.bitmap = nil
      @currentFrame = 0
      @counter = 0
      return
    end
    @animBitmap = AnimatedBitmap.new(GameData::Species.icon_filename_from_pokemon_kojo(value))
    @w = @animBitmap.bitmap.width
    @frames = [
        Rect.new(0,0,@w/4,@w/4),
        Rect.new(@w/4,0,@w/4,@w/4),
        Rect.new(@w/2,0,@w/4,@w/4),
        Rect.new(@w*3/4,0,@w/4,@w/4)
    ]
    if @w/4 == 40*2
    	@adjusted_x = -12
        @adjusted_y = -4
    elsif @w/4 == 44*2
        @adjusted_x = -12
        @adjusted_y = -4
    elsif @w/4 == 64*2
        @adjusted_x = -36
    	@adjusted_y = -56
    end
    self.bitmap = @animBitmap.bitmap
    self.src_rect=@frames[@animframe]
    #self.src_rect.width  = @animBitmap.height
    #self.src_rect.height = @animBitmap.height
    @numFrames    = @animBitmap.width / @animBitmap.height
    @currentFrame = 0 if @currentFrame >= @numFrames
    changeOrigin
  end

  def setOffset(offset = PictureOrigin::CENTER)
    @offset = offset
    changeOrigin
  end

  def changeOrigin
    return if !self.bitmap
    @offset = PictureOrigin::TOP_LEFT if !@offset
    case @offset
    when PictureOrigin::TOP_LEFT, PictureOrigin::LEFT, PictureOrigin::BOTTOM_LEFT
      self.ox = 0
    when PictureOrigin::TOP, PictureOrigin::CENTER, PictureOrigin::BOTTOM
      self.ox = self.src_rect.width / 2
    when PictureOrigin::TOP_RIGHT, PictureOrigin::RIGHT, PictureOrigin::BOTTOM_RIGHT
      self.ox = self.src_rect.width
    end
    case @offset
    when PictureOrigin::TOP_LEFT, PictureOrigin::TOP, PictureOrigin::TOP_RIGHT
      self.oy = 0
    when PictureOrigin::LEFT, PictureOrigin::CENTER, PictureOrigin::RIGHT
      # NOTE: This assumes the top quarter of the icon is blank, so oy is placed
      #       in the middle of the lower three quarters of the image.
      self.oy = self.src_rect.height * 5 / 8
    when PictureOrigin::BOTTOM_LEFT, PictureOrigin::BOTTOM, PictureOrigin::BOTTOM_RIGHT
      self.oy = self.src_rect.height
    end
  end

  # How long to show each frame of the icon for
  def counterLimit
    return 0 if @pokemon.fainted?    # Fainted - no animation
    # ret is initially the time a whole animation cycle lasts. It is divided by
    # the number of frames in that cycle at the end.
    ret = Graphics.frame_rate / 4               # Green HP - 0.25 seconds
    if @pokemon.hp <= @pokemon.totalhp / 4      # Red HP - 1 second
      ret *= 4
    elsif @pokemon.hp <= @pokemon.totalhp / 2   # Yellow HP - 0.5 seconds
      ret *= 2
    end
    ret /= @numFrames
    ret = 1 if ret < 1
    return ret
  end

  #def update
    #return if !@animBitmap
    #super
    #@animBitmap.update
    #self.bitmap = @animBitmap.bitmap
    # Update animation
    #cl = self.counterLimit
    #if cl == 0
      #@currentFrame = 0
    #else
      #@counter += 1
      #if @counter >= cl
        #@currentFrame = (@currentFrame + 1) % @numFrames
        #@counter = 0
      #end
    #end
    #self.src_rect.x = self.src_rect.width * @currentFrame
    # Update "jumping" animation (used in party screen)
    #if @selected
      #@adjusted_x = 4
      #@adjusted_y = (@currentFrame >= @numFrames / 2) ? -2 : 6
    #else
      #@adjusted_x = 0
      #@adjusted_y = 0
    #end
    #self.x = self.x
    #self.y = self.y
  #end
end



#===============================================================================
# Pokémon icon (for species)
#===============================================================================
class PokemonSpeciesIconSprite < SpriteWrapper
  attr_accessor :selected
  attr_accessor :active
  attr_reader :species
  attr_reader :gender
  attr_reader :form
  attr_reader :x
  attr_reader :y
  attr_reader :shiny

  def initialize(species, viewport = nil)
    super(viewport)
    @animBitmap=nil
    @frames=[
       Rect.new(0,0,64,64),
       Rect.new(64,0,64,64),#Rect.new(64,0,64,64) CHANGED
       Rect.new(128,0,64,64),
       Rect.new(192,0,64,64)
    ]
    @animframe=0
    @frame=0
    @x=0
    @y=0
    @adjusted_x=0
    @adjusted_y=0
    @species      = species
    @gender       = 0
    @form         = 0
    @shiny        = 0
    @numFrames    = 0
    @currentFrame = 0
    @counter      = 0
    refresh
  end

  def dispose
    @animBitmap&.dispose
    super
  end

  def species=(value)
    @species = value
    refresh
  end

  def gender=(value)
    @gender = value
    refresh
  end

  def form=(value)
    @form = value
    refresh
  end

  def shiny=(value)
    @shiny = value
    refresh
  end

  def pbSetParams(species, gender, form, shiny = false)
    @species = species
    @gender  = gender
    @form    = form
    @shiny   = shiny
    refresh
  end

  def setOffset(offset = PictureOrigin::CENTER)
    @offset = offset
    changeOrigin
  end

  def changeOrigin
    return if !self.bitmap
    @offset = PictureOrigin::TOP_LEFT if !@offset
    case @offset
    when PictureOrigin::TOP_LEFT, PictureOrigin::LEFT, PictureOrigin::BOTTOM_LEFT
      self.ox = 0
    when PictureOrigin::TOP, PictureOrigin::CENTER, PictureOrigin::BOTTOM
      self.ox = self.src_rect.width / 2
    when PictureOrigin::TOP_RIGHT, PictureOrigin::RIGHT, PictureOrigin::BOTTOM_RIGHT
      self.ox = self.src_rect.width
    end
    case @offset
    when PictureOrigin::TOP_LEFT, PictureOrigin::TOP, PictureOrigin::TOP_RIGHT
      self.oy = 0
    when PictureOrigin::LEFT, PictureOrigin::CENTER, PictureOrigin::RIGHT
      # NOTE: This assumes the top quarter of the icon is blank, so oy is placed
      #       in the middle of the lower three quarters of the image.
      self.oy = self.src_rect.height * 5 / 8
    when PictureOrigin::BOTTOM_LEFT, PictureOrigin::BOTTOM, PictureOrigin::BOTTOM_RIGHT
      self.oy = self.src_rect.height
    end
  end

  # How long to show each frame of the icon for
  def counterLimit
    # ret is initially the time a whole animation cycle lasts. It is divided by
    # the number of frames in that cycle at the end.
    ret = Graphics.frame_rate / 4   # 0.25 seconds
    ret /= @numFrames
    ret = 1 if ret < 1
    return ret
  end

  def refresh
    @animBitmap&.dispose
    @animBitmap = nil
    bitmapFileName = GameData::Species.icon_filename_kojo(@species, @form, @gender, @shiny)
    return if !bitmapFileName
    @animBitmap = AnimatedBitmap.new(bitmapFileName)
    ###
    @w = @animBitmap.bitmap.width
    @frames = [
      Rect.new(0,0,@w/4,@w/4),
      Rect.new(@w/4,0,@w/4,@w/4),
      Rect.new(@w/2,0,@w/4,@w/4),
      Rect.new(@w*3/4,0,@w/4,@w/4)
    ]
    if @w/4 == 40*2
      @adjusted_x = -12
      @adjusted_y = -4
    elsif @w/4 == 44*2
      @adjusted_x = -12
      @adjusted_y = -4
    elsif @w/4 == 64*2
      @adjusted_x = -36
      @adjusted_y = -56
    end
    ###
    self.bitmap=@animBitmap.bitmap
    self.src_rect=@frames[@animframe]

    #self.src_rect.width  = @animBitmap.height
    #self.src_rect.height = @animBitmap.height
    #@numFrames = @animBitmap.width / @animBitmap.height
    #@currentFrame = 0 if @currentFrame>=@numFrames
    #changeOrigin
  end

  def update
    return if !@animBitmap
    @updating=true
    super
    @animBitmap.update
    self.bitmap = @animBitmap.bitmap
    self.src_rect=@frames[@animframe]
    # Update animation
    #frameskip=5
    #@frame+=1
    #@frame=0 if @frame>10
    #if @frame>=frameskip
      #@animframe=(@animframe==1) ? 0 : 1
      #self.src_rect=@frames[@animframe]
      #@frame=0
    #end
    frameskip=8
    @frame+=1
    @frame=0 if @frame>100
    if @frame % frameskip == 0#@frame>=frameskip && (@frame % 8 == 0)
      #(@animframe==1) ? 0 : 1
      #Kernel.echo(@animframe)
      self.src_rect=@frames[@animframe]
      #@frame=0
      @animframe += 1
      if @animframe == 4
        @animframe = 0
      end
    end
    @updating=false
    self.x=self.x
    self.y=self.y

  end
end
