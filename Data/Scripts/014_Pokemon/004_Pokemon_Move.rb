#===============================================================================
# Move objects known by Pokémon.
#===============================================================================
class Pokemon
  class Move
    # This move's ID.
    attr_reader :id
    # The amount of PP remaining for this move.
    attr_reader :pp
    # The number of PP Ups used on this move (each one adds 20% to the total PP).
    attr_reader :ppup

    # Creates a new Move object.
    # @param move_id [Symbol, String, GameData::Move] move ID
    def initialize(move_id)
      @id   = GameData::Move.get(move_id).id
      @ppup = 0
      @pp   = total_pp
    end

    # Sets this move's ID, and caps the PP amount if it is now greater than this
    # move's total PP.
    # @param value [Symbol, String, GameData::Move] the new move ID
    def id=(value)
      @id = GameData::Move.get(value).id
      @pp = @pp.clamp(0, total_pp)
    end

    # Sets this move's PP, capping it at this move's total PP.
    # @param value [Integer] the new PP amount
    def pp=(value)
      @pp = value.clamp(0, total_pp)
    end

    # Sets this move's PP Up count, and caps the PP if necessary.
    # @param value [Integer] the new PP Up value
    def ppup=(value)
      @ppup = value
      @pp = @pp.clamp(0, total_pp)
    end

    # Returns the total PP of this move, taking PP Ups into account.
    # @return [Integer] total PP
    def total_pp
      max_pp = GameData::Move.get(@id).total_pp
      return max_pp + (max_pp * @ppup / 5)
    end
    alias totalpp total_pp

    def function_code;  return GameData::Move.get(@id).function_code; end
    def power;          return GameData::Move.get(@id).power;         end
    def type;           return GameData::Move.get(@id).type;          end
    def category;       return GameData::Move.get(@id).category;      end
    def physical_move?; return GameData::Move.get(@id).physical?;     end
    def special_move?;  return GameData::Move.get(@id).special?;      end
    def status_move?;   return GameData::Move.get(@id).status?;       end
    def accuracy;       return GameData::Move.get(@id).accuracy;      end
    def effect_chance;  return GameData::Move.get(@id).effect_chance; end
    def target;         return GameData::Move.get(@id).target;        end
    def priority;       return GameData::Move.get(@id).priority;      end
    def flags;          return GameData::Move.get(@id).flags;         end
    def name;           return GameData::Move.get(@id).name;          end
    def description;    return GameData::Move.get(@id).description;   end
    def hidden_move?;   return GameData::Move.get(@id).hidden_move?;  end

    # @deprecated This method is slated to be removed in v22.
    def base_damage
      Deprecation.warn_method("base_damage", "v22", "power")
      return @power
    end

    def display_type(pkmn);     return GameData::Move.get(@id).display_type(pkmn, self);     end
    def display_category(pkmn); return GameData::Move.get(@id).display_category(pkmn, self); end
    def display_damage(pkmn);   return GameData::Move.get(@id).display_damage(pkmn, self);   end
    def display_accuracy(pkmn); return GameData::Move.get(@id).display_accuracy(pkmn, self); end
  end
end

#===============================================================================
# Legacy move object known by Pokémon.
#===============================================================================
# @deprecated Use {Pokemon#Move} instead. PBMove is slated to be removed in v20.
class PBMove
  attr_reader :id, :pp, :ppup

  def self.convert(move)
	new_move = convertMove(move.id)
    ret = Pokemon::Move.new(new_move)
    ret.ppup = move.ppup
    ret.pp = move.pp
    return ret
  end
  
  def self.convertMove(move)
    case move
    when 1 then move = "MEGAHORN"
    when 2 then move = "ATTACKORDER"
    when 3 then move = "BUGBUZZ"
    when 4 then move = "XSCISSOR"
    when 5 then move = "SIGNALBEAM"
    when 6 then move = "UTURN"
    when 7 then move = "STEAMROLLER"
    when 8 then move = "BUGBITE"
    when 9 then move = "SILVERWIND"
    when 10 then move = "STRUGGLEBUG"
    when 11 then move = "TWINEEDLE"
    when 12 then move = "FURYCUTTER"
    when 13 then move = "LEECHLIFE"
    when 14 then move = "PINMISSILE"
    when 15 then move = "DEFENDORDER"
    when 16 then move = "HEALORDER"
    when 17 then move = "QUIVERDANCE"
    when 18 then move = "RAGEPOWDER"
    when 19 then move = "SPIDERWEB"
    when 20 then move = "STRINGSHOT"
    when 21 then move = "TAILGLOW"
    when 22 then move = "FOULPLAY"
    when 23 then move = "NIGHTDAZE"
    when 24 then move = "CRUNCH"
    when 25 then move = "DARKPULSE"
    when 26 then move = "SUCKERPUNCH"
    when 27 then move = "NIGHTSLASH"
    when 28 then move = "BITE"
    when 29 then move = "FEINTATTACK"
    when 30 then move = "SNARL"
    when 31 then move = "ASSURANCE"
    when 32 then move = "PAYBACK"
    when 33 then move = "PURSUIT"
    when 34 then move = "THIEF"
    when 35 then move = "KNOCKOFF"
    when 36 then move = "BEATUP"
    when 37 then move = "FLING"
    when 38 then move = "PUNISHMENT"
    when 39 then move = "DARKVOID"
    when 40 then move = "EMBARGO"
    when 41 then move = "FAKETEARS"
    when 42 then move = "FLATTER"
    when 43 then move = "HONECLAWS"
    when 44 then move = "MEMENTO"
    when 45 then move = "NASTYPLOT"
    when 46 then move = "QUASH"
    when 47 then move = "SNATCH"
    when 48 then move = "SWITCHEROO"
    when 49 then move = "TAUNT"
    when 50 then move = "TORMENT"
    when 51 then move = "ROAROFTIME"
    when 52 then move = "DRACOMETEOR"
    when 53 then move = "OUTRAGE"
    when 54 then move = "DRAGONRUSH"
    when 55 then move = "SPACIALREND"
    when 56 then move = "DRAGONPULSE"
    when 57 then move = "DRAGONCLAW"
    when 58 then move = "DRAGONTAIL"
    when 59 then move = "DRAGONBREATH"
    when 60 then move = "DUALCHOP"
    when 61 then move = "TWISTER"
    when 62 then move = "DRAGONRAGE"
    when 63 then move = "DRAGONDANCE"
    when 64 then move = "BOLTSTRIKE"
    when 65 then move = "THUNDER"
    when 66 then move = "VOLTTACKLE"
    when 67 then move = "ZAPCANNON"
    when 68 then move = "FUSIONBOLT"
    when 69 then move = "THUNDERBOLT"
    when 70 then move = "WILDCHARGE"
    when 71 then move = "DISCHARGE"
    when 72 then move = "THUNDERPUNCH"
    when 73 then move = "VOLTSWITCH"
    when 74 then move = "SPARK"
    when 75 then move = "THUNDERFANG"
    when 76 then move = "SHOCKWAVE"
    when 77 then move = "ELECTROWEB"
    when 78 then move = "CHARGEBEAM"
    when 79 then move = "THUNDERSHOCK"
    when 80 then move = "ELECTROBALL"
    when 81 then move = "CHARGE"
    when 82 then move = "MAGNETRISE"
    when 83 then move = "THUNDERWAVE"
    when 84 then move = "FOCUSPUNCH"
    when 85 then move = "HIGHJUMPKICK"
    when 86 then move = "CLOSECOMBAT"
    when 87 then move = "FOCUSBLAST"
    when 88 then move = "SUPERPOWER"
    when 89 then move = "CROSSCHOP"
    when 90 then move = "DYNAMICPUNCH"
    when 91 then move = "HAMMERARM"
    when 92 then move = "JUMPKICK"
    when 93 then move = "AURASPHERE"
    when 94 then move = "SACREDSWORD"
    when 95 then move = "SECRETSWORD"
    when 96 then move = "SKYUPPERCUT"
    when 97 then move = "SUBMISSION"
    when 98 then move = "BRICKBREAK"
    when 99 then move = "DRAINPUNCH"
    when 100 then move = "VITALTHROW"
    when 101 then move = "CIRCLETHROW"
    when 102 then move = "FORCEPALM"
    when 103 then move = "LOWSWEEP"
    when 104 then move = "REVENGE"
    when 105 then move = "ROLLINGKICK"
    when 106 then move = "WAKEUPSLAP"
    when 107 then move = "KARATECHOP"
    when 108 then move = "MACHPUNCH"
    when 109 then move = "ROCKSMASH"
    when 110 then move = "STORMTHROW"
    when 111 then move = "VACUUMWAVE"
    when 112 then move = "DOUBLEKICK"
    when 113 then move = "ARMTHRUST"
    when 114 then move = "TRIPLEKICK"
    when 115 then move = "COUNTER"
    when 116 then move = "FINALGAMBIT"
    when 117 then move = "LOWKICK"
    when 118 then move = "REVERSAL"
    when 119 then move = "SEISMICTOSS"
    when 120 then move = "BULKUP"
    when 121 then move = "DETECT"
    when 122 then move = "QUICKGUARD"
    when 123 then move = "VCREATE"
    when 124 then move = "BLASTBURN"
    when 125 then move = "ERUPTION"
    when 126 then move = "OVERHEAT"
    when 127 then move = "BLUEFLARE"
    when 128 then move = "FIREBLAST"
    when 129 then move = "FLAREBLITZ"
    when 130 then move = "MAGMASTORM"
    when 131 then move = "FUSIONFLARE"
    when 132 then move = "HEATWAVE"
    when 133 then move = "INFERNO"
    when 134 then move = "SACREDFIRE"
    when 135 then move = "SEARINGSHOT"
    when 136 then move = "FLAMETHROWER"
    when 137 then move = "BLAZEKICK"
    when 138 then move = "FIERYDANCE"
    when 139 then move = "LAVAPLUME"
    when 140 then move = "FIREPUNCH"
    when 141 then move = "FLAMEBURST"
    when 142 then move = "FIREFANG"
    when 143 then move = "FLAMEWHEEL"
    when 144 then move = "FIREPLEDGE"
    when 145 then move = "FLAMECHARGE"
    when 146 then move = "EMBER"
    when 147 then move = "FIRESPIN"
    when 148 then move = "INCINERATE"
    when 149 then move = "HEATCRASH"
    when 150 then move = "SUNNYDAY"
    when 151 then move = "WILLOWISP"
    when 152 then move = "SKYATTACK"
    when 153 then move = "BRAVEBIRD"
    when 154 then move = "HURRICANE"
    when 155 then move = "AEROBLAST"
    when 156 then move = "FLY"
    when 157 then move = "BOUNCE"
    when 158 then move = "DRILLPECK"
    when 159 then move = "AIRSLASH"
    when 160 then move = "AERIALACE"
    when 161 then move = "CHATTER"
    when 162 then move = "PLUCK"
    when 163 then move = "SKYDROP"
    when 164 then move = "WINGATTACK"
    when 165 then move = "ACROBATICS"
    when 166 then move = "AIRCUTTER"
    when 167 then move = "GUST"
    when 168 then move = "PECK"
    when 169 then move = "DEFOG"
    when 170 then move = "FEATHERDANCE"
    when 171 then move = "MIRRORMOVE"
    when 172 then move = "ROOST"
    when 173 then move = "TAILWIND"
    when 174 then move = "SHADOWFORCE"
    when 175 then move = "SHADOWBALL"
    when 176 then move = "SHADOWCLAW"
    when 177 then move = "OMINOUSWIND"
    when 178 then move = "SHADOWPUNCH"
    when 179 then move = "HEX"
    when 180 then move = "SHADOWSNEAK"
    when 181 then move = "ASTONISH"
    when 182 then move = "LICK"
    when 183 then move = "NIGHTSHADE"
    when 184 then move = "CONFUSERAY"
    when 185 then move = "CURSE"
    when 186 then move = "DESTINYBOND"
    when 187 then move = "GRUDGE"
    when 188 then move = "NIGHTMARE"
    when 189 then move = "SPITE"
    when 190 then move = "FRENZYPLANT"
    when 191 then move = "LEAFSTORM"
    when 192 then move = "PETALDANCE"
    when 193 then move = "POWERWHIP"
    when 194 then move = "SEEDFLARE"
    when 195 then move = "SOLARBEAM"
    when 196 then move = "WOODHAMMER"
    when 197 then move = "LEAFBLADE"
    when 198 then move = "ENERGYBALL"
    when 199 then move = "SEEDBOMB"
    when 200 then move = "GIGADRAIN"
    when 201 then move = "HORNLEECH"
    when 202 then move = "LEAFTORNADO"
    when 203 then move = "MAGICALLEAF"
    when 204 then move = "NEEDLEARM"
    when 205 then move = "RAZORLEAF"
    when 206 then move = "GRASSPLEDGE"
    when 207 then move = "MEGADRAIN"
    when 208 then move = "VINEWHIP"
    when 209 then move = "BULLETSEED"
    when 210 then move = "ABSORB"
    when 211 then move = "GRASSKNOT"
    when 212 then move = "AROMATHERAPY"
    when 213 then move = "COTTONGUARD"
    when 214 then move = "COTTONSPORE"
    when 215 then move = "GRASSWHISTLE"
    when 216 then move = "INGRAIN"
    when 217 then move = "LEECHSEED"
    when 218 then move = "SLEEPPOWDER"
    when 219 then move = "SPORE"
    when 220 then move = "STUNSPORE"
    when 221 then move = "SYNTHESIS"
    when 222 then move = "WORRYSEED"
    when 223 then move = "EARTHQUAKE"
    when 224 then move = "EARTHPOWER"
    when 225 then move = "DIG"
    when 226 then move = "DRILLRUN"
    when 227 then move = "BONECLUB"
    when 228 then move = "MUDBOMB"
    when 229 then move = "BULLDOZE"
    when 230 then move = "MUDSHOT"
    when 231 then move = "BONEMERANG"
    when 232 then move = "SANDTOMB"
    when 233 then move = "BONERUSH"
    when 234 then move = "MUDSLAP"
    when 235 then move = "FISSURE"
    when 236 then move = "MAGNITUDE"
    when 237 then move = "MUDSPORT"
    when 238 then move = "SANDATTACK"
    when 239 then move = "SPIKES"
    when 240 then move = "FREEZESHOCK"
    when 241 then move = "ICEBURN"
    when 242 then move = "BLIZZARD"
    when 243 then move = "ICEBEAM"
    when 244 then move = "ICICLECRASH"
    when 245 then move = "ICEPUNCH"
    when 246 then move = "AURORABEAM"
    when 247 then move = "GLACIATE"
    when 248 then move = "ICEFANG"
    when 249 then move = "AVALANCHE"
    when 250 then move = "ICYWIND"
    when 251 then move = "FROSTBREATH"
    when 252 then move = "ICESHARD"
    when 253 then move = "POWDERSNOW"
    when 254 then move = "ICEBALL"
    when 255 then move = "ICICLESPEAR"
    when 256 then move = "SHEERCOLD"
    when 257 then move = "HAIL"
    when 258 then move = "HAZE"
    when 259 then move = "MIST"
    when 260 then move = "EXPLOSION"
    when 261 then move = "SELFDESTRUCT"
    when 262 then move = "GIGAIMPACT"
    when 263 then move = "HYPERBEAM"
    when 264 then move = "LASTRESORT"
    when 265 then move = "DOUBLEEDGE"
    when 266 then move = "HEADCHARGE"
    when 267 then move = "MEGAKICK"
    when 268 then move = "THRASH"
    when 269 then move = "EGGBOMB"
    when 270 then move = "JUDGMENT"
    when 271 then move = "SKULLBASH"
    when 272 then move = "HYPERVOICE"
    when 273 then move = "ROCKCLIMB"
    when 274 then move = "TAKEDOWN"
    when 275 then move = "UPROAR"
    when 276 then move = "BODYSLAM"
    when 277 then move = "TECHNOBLAST"
    when 278 then move = "EXTREMESPEED"
    when 279 then move = "HYPERFANG"
    when 280 then move = "MEGAPUNCH"
    when 281 then move = "RAZORWIND"
    when 282 then move = "SLAM"
    when 283 then move = "STRENGTH"
    when 284 then move = "TRIATTACK"
    when 285 then move = "CRUSHCLAW"
    when 286 then move = "RELICSONG"
    when 287 then move = "CHIPAWAY"
    when 288 then move = "DIZZYPUNCH"
    when 289 then move = "FACADE"
    when 290 then move = "HEADBUTT"
    when 291 then move = "RETALIATE"
    when 292 then move = "SECRETPOWER"
    when 293 then move = "SLASH"
    when 294 then move = "HORNATTACK"
    when 295 then move = "STOMP"
    when 296 then move = "COVET"
    when 297 then move = "ROUND"
    when 298 then move = "SMELLINGSALTS"
    when 299 then move = "SWIFT"
    when 300 then move = "VICEGRIP"
    when 301 then move = "CUT"
    when 302 then move = "STRUGGLE"
    when 303 then move = "TACKLE"
    when 304 then move = "WEATHERBALL"
    when 305 then move = "ECHOEDVOICE"
    when 306 then move = "FAKEOUT"
    when 307 then move = "FALSESWIPE"
    when 308 then move = "PAYDAY"
    when 309 then move = "POUND"
    when 310 then move = "QUICKATTACK"
    when 311 then move = "SCRATCH"
    when 312 then move = "SNORE"
    when 313 then move = "DOUBLEHIT"
    when 314 then move = "FEINT"
    when 315 then move = "TAILSLAP"
    when 316 then move = "RAGE"
    when 317 then move = "RAPIDSPIN"
    when 318 then move = "SPIKECANNON"
    when 319 then move = "COMETPUNCH"
    when 320 then move = "FURYSWIPES"
    when 321 then move = "BARRAGE"
    when 322 then move = "BIND"
    when 323 then move = "DOUBLESLAP"
    when 324 then move = "FURYATTACK"
    when 325 then move = "WRAP"
    when 326 then move = "CONSTRICT"
    when 327 then move = "BIDE"
    when 328 then move = "CRUSHGRIP"
    when 329 then move = "ENDEAVOR"
    when 330 then move = "FLAIL"
    when 331 then move = "FRUSTRATION"
    when 332 then move = "GUILLOTINE"
    when 333 then move = "HIDDENPOWER"
    when 334 then move = "HORNDRILL"
    when 335 then move = "NATURALGIFT"
    when 336 then move = "PRESENT"
    when 337 then move = "RETURN"
    when 338 then move = "SONICBOOM"
    when 339 then move = "SPITUP"
    when 340 then move = "SUPERFANG"
    when 341 then move = "TRUMPCARD"
    when 342 then move = "WRINGOUT"
    when 343 then move = "ACUPRESSURE"
    when 344 then move = "AFTERYOU"
    when 345 then move = "ASSIST"
    when 346 then move = "ATTRACT"
    when 347 then move = "BATONPASS"
    when 348 then move = "BELLYDRUM"
    when 349 then move = "BESTOW"
    when 350 then move = "BLOCK"
    when 351 then move = "CAMOUFLAGE"
    when 352 then move = "CAPTIVATE"
    when 353 then move = "CHARM"
    when 354 then move = "CONVERSION"
    when 355 then move = "CONVERSION2"
    when 356 then move = "COPYCAT"
    when 357 then move = "DEFENSECURL"
    when 358 then move = "DISABLE"
    when 359 then move = "DOUBLETEAM"
    when 360 then move = "ENCORE"
    when 361 then move = "ENDURE"
    when 362 then move = "ENTRAINMENT"
    when 363 then move = "FLASH"
    when 364 then move = "FOCUSENERGY"
    when 365 then move = "FOLLOWME"
    when 366 then move = "FORESIGHT"
    when 367 then move = "GLARE"
    when 368 then move = "GROWL"
    when 369 then move = "GROWTH"
    when 370 then move = "HARDEN"
    when 371 then move = "HEALBELL"
    when 372 then move = "HELPINGHAND"
    when 373 then move = "HOWL"
    when 374 then move = "LEER"
    when 375 then move = "LOCKON"
    when 376 then move = "LOVELYKISS"
    when 377 then move = "LUCKYCHANT"
    when 378 then move = "MEFIRST"
    when 379 then move = "MEANLOOK"
    when 380 then move = "METRONOME"
    when 381 then move = "MILKDRINK"
    when 382 then move = "MIMIC"
    when 383 then move = "MINDREADER"
    when 384 then move = "MINIMIZE"
    when 385 then move = "MOONLIGHT"
    when 386 then move = "MORNINGSUN"
    when 387 then move = "NATUREPOWER"
    when 388 then move = "ODORSLEUTH"
    when 389 then move = "PAINSPLIT"
    when 390 then move = "PERISHSONG"
    when 391 then move = "PROTECT"
    when 392 then move = "PSYCHUP"
    when 393 then move = "RECOVER"
    when 394 then move = "RECYCLE"
    when 395 then move = "REFLECTTYPE"
    when 396 then move = "REFRESH"
    when 397 then move = "ROAR"
    when 398 then move = "SAFEGUARD"
    when 399 then move = "SCARYFACE"
    when 400 then move = "SCREECH"
    when 401 then move = "SHARPEN"
    when 402 then move = "SHELLSMASH"
    when 403 then move = "SIMPLEBEAM"
    when 404 then move = "SING"
    when 405 then move = "SKETCH"
    when 406 then move = "SLACKOFF"
    when 407 then move = "SLEEPTALK"
    when 408 then move = "SMOKESCREEN"
    when 409 then move = "SOFTBOILED"
    when 410 then move = "SPLASH"
    when 411 then move = "STOCKPILE"
    when 412 then move = "SUBSTITUTE"
    when 413 then move = "SUPERSONIC"
    when 414 then move = "SWAGGER"
    when 415 then move = "SWALLOW"
    when 416 then move = "SWEETKISS"
    when 417 then move = "SWEETSCENT"
    when 418 then move = "SWORDSDANCE"
    when 419 then move = "TAILWHIP"
    when 420 then move = "TEETERDANCE"
    when 421 then move = "TICKLE"
    when 422 then move = "TRANSFORM"
    when 423 then move = "WHIRLWIND"
    when 424 then move = "WISH"
    when 425 then move = "WORKUP"
    when 426 then move = "YAWN"
    when 427 then move = "GUNKSHOT"
    when 428 then move = "SLUDGEWAVE"
    when 429 then move = "SLUDGEBOMB"
    when 430 then move = "POISONJAB"
    when 431 then move = "CROSSPOISON"
    when 432 then move = "SLUDGE"
    when 433 then move = "VENOSHOCK"
    when 434 then move = "CLEARSMOG"
    when 435 then move = "POISONFANG"
    when 436 then move = "POISONTAIL"
    when 437 then move = "ACID"
    when 438 then move = "ACIDSPRAY"
    when 439 then move = "SMOG"
    when 440 then move = "POISONSTING"
    when 441 then move = "ACIDARMOR"
    when 442 then move = "COIL"
    when 443 then move = "GASTROACID"
    when 444 then move = "POISONGAS"
    when 445 then move = "POISONPOWDER"
    when 446 then move = "TOXIC"
    when 447 then move = "TOXICSPIKES"
    when 448 then move = "PSYCHOBOOST"
    when 449 then move = "DREAMEATER"
    when 450 then move = "FUTURESIGHT"
    when 451 then move = "PSYSTRIKE"
    when 452 then move = "PSYCHIC"
    when 453 then move = "EXTRASENSORY"
    when 454 then move = "PSYSHOCK"
    when 455 then move = "ZENHEADBUTT"
    when 456 then move = "LUSTERPURGE"
    when 457 then move = "MISTBALL"
    when 458 then move = "PSYCHOCUT"
    when 459 then move = "SYNCHRONOISE"
    when 460 then move = "PSYBEAM"
    when 461 then move = "HEARTSTAMP"
    when 462 then move = "CONFUSION"
    when 463 then move = "MIRRORCOAT"
    when 464 then move = "PSYWAVE"
    when 465 then move = "STOREDPOWER"
    when 466 then move = "AGILITY"
    when 467 then move = "ALLYSWITCH"
    when 468 then move = "AMNESIA"
    when 469 then move = "BARRIER"
    when 470 then move = "CALMMIND"
    when 471 then move = "COSMICPOWER"
    when 472 then move = "GRAVITY"
    when 473 then move = "GUARDSPLIT"
    when 474 then move = "GUARDSWAP"
    when 475 then move = "HEALBLOCK"
    when 476 then move = "HEALPULSE"
    when 477 then move = "HEALINGWISH"
    when 478 then move = "HEARTSWAP"
    when 479 then move = "HYPNOSIS"
    when 480 then move = "IMPRISON"
    when 481 then move = "KINESIS"
    when 482 then move = "LIGHTSCREEN"
    when 483 then move = "LUNARDANCE"
    when 484 then move = "MAGICCOAT"
    when 485 then move = "MAGICROOM"
    when 486 then move = "MEDITATE"
    when 487 then move = "MIRACLEEYE"
    when 488 then move = "POWERSPLIT"
    when 489 then move = "POWERSWAP"
    when 490 then move = "POWERTRICK"
    when 491 then move = "PSYCHOSHIFT"
    when 492 then move = "REFLECT"
    when 493 then move = "REST"
    when 494 then move = "ROLEPLAY"
    when 495 then move = "SKILLSWAP"
    when 496 then move = "TELEKINESIS"
    when 497 then move = "TELEPORT"
    when 498 then move = "TRICK"
    when 499 then move = "TRICKROOM"
    when 500 then move = "WONDERROOM"
    when 501 then move = "HEADSMASH"
    when 502 then move = "ROCKWRECKER"
    when 503 then move = "STONEEDGE"
    when 504 then move = "ROCKSLIDE"
    when 505 then move = "POWERGEM"
    when 506 then move = "ANCIENTPOWER"
    when 507 then move = "ROCKTHROW"
    when 508 then move = "ROCKTOMB"
    when 509 then move = "SMACKDOWN"
    when 510 then move = "ROLLOUT"
    when 511 then move = "ROCKBLAST"
    when 512 then move = "ROCKPOLISH"
    when 513 then move = "SANDSTORM"
    when 514 then move = "STEALTHROCK"
    when 515 then move = "WIDEGUARD"
    when 516 then move = "DOOMDESIRE"
    when 517 then move = "IRONTAIL"
    when 518 then move = "METEORMASH"
    when 519 then move = "FLASHCANNON"
    when 520 then move = "IRONHEAD"
    when 521 then move = "STEELWING"
    when 522 then move = "MIRRORSHOT"
    when 523 then move = "MAGNETBOMB"
    when 524 then move = "GEARGRIND"
    when 525 then move = "METALCLAW"
    when 526 then move = "BULLETPUNCH"
    when 527 then move = "GYROBALL"
    when 528 then move = "HEAVYSLAM"
    when 529 then move = "METALBURST"
    when 530 then move = "AUTOTOMIZE"
    when 531 then move = "IRONDEFENSE"
    when 532 then move = "METALSOUND"
    when 533 then move = "SHIFTGEAR"
    when 534 then move = "HYDROCANNON"
    when 535 then move = "WATERSPOUT"
    when 536 then move = "HYDROPUMP"
    when 537 then move = "MUDDYWATER"
    when 538 then move = "SURF"
    when 539 then move = "AQUATAIL"
    when 540 then move = "CRABHAMMER"
    when 541 then move = "DIVE"
    when 542 then move = "SCALD"
    when 543 then move = "WATERFALL"
    when 544 then move = "RAZORSHELL"
    when 545 then move = "BRINE"
    when 546 then move = "BUBBLEBEAM"
    when 547 then move = "OCTAZOOKA"
    when 548 then move = "WATERPULSE"
    when 549 then move = "WATERPLEDGE"
    when 550 then move = "AQUAJET"
    when 551 then move = "WATERGUN"
    when 552 then move = "CLAMP"
    when 553 then move = "WHIRLPOOL"
    when 554 then move = "BUBBLE"
    when 555 then move = "AQUARING"
    when 556 then move = "RAINDANCE"
    when 557 then move = "SOAK"
    when 558 then move = "WATERSPORT"
    when 559 then move = "WITHDRAW"
    when 560 then move = "AROMATICMIST"
    when 561 then move = "BABYDOLLEYES"
    when 562 then move = "BELCH"
    when 563 then move = "BOOMBURST"
    when 564 then move = "CELEBRATE"
    when 565 then move = "CONFIDE"
    when 566 then move = "CRAFTYSHIELD"
    when 567 then move = "DAZZLINGGLEAM"
    when 568 then move = "DISARMINGVOICE"
    when 569 then move = "DRAININGKISS"
    when 570 then move = "EERIEIMPULSE"
    when 571 then move = "ELECTRICTERRAIN"
    when 572 then move = "ELECTRIFY"
    when 573 then move = "FAIRYLOCK"
    when 574 then move = "FAIRYWIND"
    when 575 then move = "FELLSTINGER"
    when 576 then move = "FLOWERSHIELD"
    when 577 then move = "FLYINGPRESS"
    when 578 then move = "FORESTSCURSE"
    when 579 then move = "FREEZEDRY"
    when 580 then move = "GEOMANCY"
    when 581 then move = "GRASSYTERRAIN"
    when 582 then move = "HAPPYHOUR"
    when 583 then move = "INFESTATION"
    when 584 then move = "IONDELUGE"
    when 585 then move = "KINGSSHIELD"
    when 586 then move = "LANDSWRATH"
    when 587 then move = "MAGNETICFLUX"
    when 588 then move = "MATBLOCK"
    when 589 then move = "MISTYTERRAIN"
    when 590 then move = "MOONBLAST"
    when 591 then move = "MYSTICALFIRE"
    when 592 then move = "NOBLEROAR"
    when 593 then move = "NUZZLE"
    when 594 then move = "OBLIVIONWING"
    when 595 then move = "PARABOLICCHARGE"
    when 596 then move = "PARTINGSHOT"
    when 597 then move = "PETALBLIZZARD"
    when 598 then move = "PHANTOMFORCE"
    when 599 then move = "PLAYNICE"
    when 600 then move = "PLAYROUGH"
    when 601 then move = "POWDER"
    when 602 then move = "POWERUPPUNCH"
    when 603 then move = "ROTOTILLER"
    when 604 then move = "SPIKYSHIELD"
    when 605 then move = "STICKYWEB"
    when 606 then move = "TOPSYTURVY"
    when 607 then move = "TRICKORTREAT"
    when 608 then move = "VENOMDRENCH"
    when 609 then move = "WATERSHURIKEN"
    when 610 then move = "DIAMONDSTORM"
    when 611 then move = "HYPERSPACEHOLE"
    when 612 then move = "STEAMERUPTION"
    when 613 then move = "THOUSANDARROWS"
    when 614 then move = "THOUSANDWAVES"
    when 615 then move = "LIGHTOFRUIN"
    when 616 then move = "DRAGONASCENT"
    when 617 then move = "ORIGINPULSE"
    when 618 then move = "PRECIPICEBLADES"
    when 619 then move = "HYPERSPACEFURY"
    when 620 then move = "HOLDBACK"
    when 621 then move = "HOLDHANDS"
    when 622 then move = "DRAGONHAMMER"
    when 623 then move = "PSYCHICFANGS"
    when 800 then move = "COCONUTDROP"
    when 801 then move = "FISTICUFF"
    when 802 then move = "MINDCONTROL"
    when 803 then move = "SHEEPCOUNT"
    when 804 then move = "DREAMTIME"
    when 805 then move = "ROCKYTERRAIN"
    when 806 then move = "THORNS"
    when 807 then move = "CHAMPROLL"
    when 808 then move = "JUNKTOSS"
    when 809 then move = "CONTAGIONDRAIN"
    when 810 then move = "FREEZEBLADE"
    when 811 then move = "HONEYSHOT"
    end
  end
end
