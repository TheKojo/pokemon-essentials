#===============================================================================
# Global metadata not specific to a map.  This class holds field state data that
# span multiple maps.
#===============================================================================
class PokemonGlobalMetadata
  # Movement
  attr_accessor :bicycle
  attr_accessor :surfing
  attr_accessor :diving
  attr_accessor :sliding
  attr_accessor :fishing
  # Player data
  attr_accessor :startTime
  attr_accessor :stepcount
  attr_accessor :pcItemStorage
  attr_accessor :mailbox
  attr_accessor :phoneNumbers
  attr_accessor :phoneTime
  attr_accessor :partner
  attr_accessor :creditsPlayed
  # Pokédex
  attr_accessor :pokedexUnlocked # Deprecated, replaced with Player::Pokedex#unlocked_dexes
  attr_accessor :pokedexDex      # Dex currently looking at (-1 is National Dex)
  attr_accessor :pokedexIndex    # Last species viewed per Dex
  attr_accessor :pokedexMode     # Search mode
  # Day Care
  attr_accessor :daycare
  attr_accessor :day_care
  # Special battle modes
  attr_accessor :safariState
  attr_accessor :bugContestState
  attr_accessor :challenge
  attr_accessor :lastbattle      # Saved recording of a battle
  # Events
  attr_accessor :eventvars
  # Affecting the map
  attr_accessor :bridge
  attr_accessor :repel
  attr_accessor :flashUsed
  attr_reader   :encounter_version
  # Map transfers
  attr_accessor :healingSpot
  attr_accessor :escapePoint
  attr_accessor :pokecenterMapId
  attr_accessor :pokecenterX
  attr_accessor :pokecenterY
  attr_accessor :pokecenterDirection
  # Movement history
  attr_accessor :visitedMaps
  attr_accessor :mapTrail
  # Counters
  attr_accessor :happinessSteps
  attr_accessor :pokerusTime
  # Save file
  attr_accessor :safesave

  def initialize
    # Movement
    @bicycle              = false
    @surfing              = false
    @diving               = false
    @sliding              = false
    @fishing              = false
    # Player data
    @startTime            = Time.now
    @stepcount            = 0
    @pcItemStorage        = nil
    @mailbox              = nil
    @phoneNumbers         = []
    @phoneTime            = 0
    @partner              = nil
    @creditsPlayed        = false
    # Pokédex
    numRegions            = pbLoadRegionalDexes.length
    @pokedexDex           = (numRegions == 0) ? -1 : 0
    @pokedexIndex         = []
    @pokedexMode          = 0
    (numRegions + 1).times do |i|     # National Dex isn't a region, but is included
      @pokedexIndex[i] = 0
    end
    # Day Care
    @daycare              = [[nil,0],[nil,0]]
    @day_care             = DayCare.new
    # Special battle modes
    @safariState          = nil
    @bugContestState      = nil
    @challenge            = nil
    @lastbattle           = nil
    # Events
    @eventvars            = {}
    # Affecting the map
    @bridge               = 0
    @repel                = 0
    @flashused            = false
    @encounter_version    = 0
    # Map transfers
    @healingSpot          = nil
    @escapePoint          = []
    @pokecenterMapId      = -1
    @pokecenterX          = -1
    @pokecenterY          = -1
    @pokecenterDirection  = -1
    # Movement history
    @visitedMaps          = []
    @mapTrail             = []
    # Counters
    @happinessSteps       = 0
    @pokerusTime          = nil
    # Save file
    @safesave             = false
  end

  def encounter_version=(value)
    validate value => Integer
    return if @encounter_version == value
    @encounter_version = value
    $PokemonEncounters.setup($game_map.map_id) if $PokemonEncounters && $game_map
  end
  
    # @deprecated Use {Player#character_ID} instead. This alias is slated to be removed in v20.
  def playerID
    Deprecation.warn_method('PokemonGlobalMetadata#playerID', 'v20', '$Trainer.character_ID')
    return @playerID || $Trainer.character_ID
  end

  # @deprecated Use {Player#character_ID=} instead. This alias is slated to be removed in v20.
  def playerID=(value)
    Deprecation.warn_method('PokemonGlobalMetadata#playerID=', 'v20', '$Trainer.character_ID=')
    if value.nil?
      @playerID = value   # For setting to nil by a save data conversion
    else
      $Trainer.character_ID = value
    end
  end

  # @deprecated Use {Player#coins} instead. This alias is slated to be removed in v20.
  def coins
    Deprecation.warn_method('PokemonGlobalMetadata#coins', 'v20', '$Trainer.coins')
    return @coins || $Trainer.coins
  end

  # @deprecated Use {Player#coins=} instead. This alias is slated to be removed in v20.
  def coins=(value)
    Deprecation.warn_method('PokemonGlobalMetadata#coins=', 'v20', '$Trainer.coins=')
    if value.nil?
      @coins = value   # For setting to nil by a save data conversion
    else
      $Trainer.coins = value
    end
  end

  # @deprecated Use {Player#soot} instead. This alias is slated to be removed in v20.
  def sootsack
    Deprecation.warn_method('PokemonGlobalMetadata#sootsack', 'v20', '$Trainer.soot')
    return @sootsack || $Trainer.soot
  end

  # @deprecated Use {Player#soot=} instead. This alias is slated to be removed in v20.
  def sootsack=(value)
    Deprecation.warn_method('PokemonGlobalMetadata#sootsack=', 'v20', '$Trainer.soot=')
    if value.nil?
      @sootsack = value   # For setting to nil by a save data conversion
    else
      $Trainer.soot = value
    end
  end

  # @deprecated Use {Player#has_running_shoes} instead. This alias is slated to be removed in v20.
  def runningShoes
    Deprecation.warn_method('PokemonGlobalMetadata#runningShoes', 'v20', '$Trainer.has_running_shoes')
    return (!@runningShoes.nil?) ? @runningShoes : $Trainer.has_running_shoes
  end

  # @deprecated Use {Player#has_running_shoes=} instead. This alias is slated to be removed in v20.
  def runningShoes=(value)
    Deprecation.warn_method('PokemonGlobalMetadata#runningShoes=', 'v20', '$Trainer.has_running_shoes=')
    if value.nil?
      @runningShoes = value   # For setting to nil by a save data conversion
    else
      $Trainer.has_running_shoes = value
    end
  end

  # @deprecated Use {Player#seen_storage_creator} instead. This alias is slated to be removed in v20.
  def seenStorageCreator
    Deprecation.warn_method('PokemonGlobalMetadata#seenStorageCreator', 'v20', '$Trainer.seen_storage_creator')
    return (!@seenStorageCreator.nil?) ? @seenStorageCreator : $Trainer.seen_storage_creator
  end

  # @deprecated Use {Player#seen_storage_creator=} instead. This alias is slated to be removed in v20.
  def seenStorageCreator=(value)
    Deprecation.warn_method('PokemonGlobalMetadata#seenStorageCreator=', 'v20', '$Trainer.seen_storage_creator=')
    if value.nil?
      @seenStorageCreator = value   # For setting to nil by a save data conversion
    else
      $Trainer.seen_storage_creator = value
    end
  end
end



#===============================================================================
# This class keeps track of erased and moved events so their position
# can remain after a game is saved and loaded.  This class also includes
# variables that should remain valid only for the current map.
#===============================================================================
class PokemonMapMetadata
  attr_reader :erasedEvents
  attr_reader :movedEvents
  attr_accessor :strengthUsed
  attr_accessor :blackFluteUsed
  attr_accessor :whiteFluteUsed

  def initialize
    clear
  end

  def clear
    @erasedEvents   = {}
    @movedEvents    = {}
    @strengthUsed   = false
    @blackFluteUsed = false
    @whiteFluteUsed = false
  end

  def addErasedEvent(eventID)
    key = [$game_map.map_id, eventID]
    @erasedEvents[key] = true
  end

  def addMovedEvent(eventID)
    key               = [$game_map.map_id, eventID]
    event             = $game_map.events[eventID] if eventID.is_a?(Integer)
    @movedEvents[key] = [event.x, event.y, event.direction, event.through] if event
  end

  def updateMap
    @erasedEvents.each do |i|
      $game_map.events[i[0][1]]&.erase if i[0][0] == $game_map.map_id && i[1]
    end
    @movedEvents.each do |i|
      if i[0][0] == $game_map.map_id && i[1]
        next if !$game_map.events[i[0][1]]
        $game_map.events[i[0][1]].moveto(i[1][0], i[1][1])
        case i[1][2]
        when 2 then $game_map.events[i[0][1]].turn_down
        when 4 then $game_map.events[i[0][1]].turn_left
        when 6 then $game_map.events[i[0][1]].turn_right
        when 8 then $game_map.events[i[0][1]].turn_up
        end
      end
      $game_map.events[i[0][1]].through = i[1][3] if i[1][3]
    end
  end
end
