class_name CraftableData
extends Resource

## Data representing something that can be made in the [Fabricator]

## Object name that the player sees
@export var craftable_name:String = ""

## What this object is represented as visually
@export var craftable_icon:Texture2D = null

## How much scrap by default this item costs to craft
@export_range(0, 999) var base_cost:int = 0

## Flavor text to describe what exactly this item is/does
@export_multiline var description:String = ""
