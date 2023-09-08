class_name AugmentData
extends Resource

## List of stat-value pairs that the augment contains
var stats:Dictionary = {}
## How much battery this augment will drain per/sec when added
var battery_drain:float = 0.0
## Rarity of this augment
var tier:int = 0
## Visible texture, based from highest stat
var icon:Texture2D = null
## How much scrap this augment required to craft
var craft_cost:int = 0
