extends Node


const ICON_PATH = "res://Assets/Upgrades/"
const WEAPON_PATH = "res://Assets/Weapons/"
const UPGRADES = {
	"icespear1": {
		"icon": WEAPON_PATH + "MOSH_IceSpear.png",
		"display_name": "Ice Spear",
		"details": "A spear of ice is thrown at a random enemy",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"icespear2": {
		"icon": WEAPON_PATH + "MOSH_IceSpear.png",
		"display_name": "Ice Spear",
		"details": "An addition Ice Spear is thrown",
		"level": "Level: 2",
		"prerequisite": ["icespear1"],
		"type": "weapon"
	},
	"icespear3": {
		"icon": WEAPON_PATH + "MOSH_IceSpear.png",
		"display_name": "Ice Spear",
		"details": "Ice Spears now pass through another enemy and do + 3 damage",
		"level": "Level: 3",
		"prerequisite": ["icespear2"],
		"type": "weapon"
	},
	"icespear4": {
		"icon": WEAPON_PATH + "MOSH_IceSpear.png",
		"display_name": "Ice Spear",
		"details": "An additional 2 Ice Spears are thrown",
		"level": "Level: 4",
		"prerequisite": ["icespear3"],
		"type": "weapon"
	},
	"boulder1": {
		"icon": WEAPON_PATH + "MOSH_Boulder.png",
		"display_name": "Boulder",
		"details": "Massive boulders slam in enemies and hit large groups",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"boulder2": {
		"icon": WEAPON_PATH + "MOSH_Boulder.png",
		"display_name": "Boulder",
		"details": "An additional boulder is thrown",
		"level": "Level: 2",
		"prerequisite": ["boulder1"],
		"type": "weapon"
	},
	"boulder3": {
		"icon": WEAPON_PATH + "MOSH_Boulder.png",
		"display_name": "Boulder",
		"details": "Boulders now do more damage",
		"level": "Level: 3",
		"prerequisite": ["boulder2"],
		"type": "weapon"
	},
	"boulder4": {
		"icon": WEAPON_PATH + "MOSH_Boulder.png",
		"display_name": "Boulder",
		"details": "An additional 2 boulders are thrown",
		"level": "Level: 4",
		"prerequisite": ["boulder3"],
		"type": "weapon"
	},
	"flamethrower1": {
		"icon": WEAPON_PATH + "MOSH_Fireball.png",
		"display_name": "Flamethrower",
		"details": "Balls of fire are rapidly thrown at a random enemy",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"flamethrower2": {
		"icon": WEAPON_PATH + "MOSH_Fireball.png",
		"display_name": "Flamethrower",
		"details": "Fire pierces through an additional enemy and does more damage",
		"level": "Level: 2",
		"prerequisite": ["flamethrower1"],
		"type": "weapon"
	},
	"flamethrower3": {
		"icon": WEAPON_PATH + "MOSH_Fireball.png",
		"display_name": "Flamethrower",
		"details": "Fire pierces through an additional two enemies",
		"level": "Level: 3",
		"prerequisite": ["flamethrower2"],
		"type": "weapon"
	},
	"flamethrower4": {
		"icon": WEAPON_PATH + "MOSH_Fireball.png",
		"display_name": "Flamethrower",
		"details": "Fire does even more damage and projectile size is increased",
		"level": "Level: 4",
		"prerequisite": ["flamethrower3"],
		"type": "weapon"
	},
	"magic_missile1": {
		"icon": WEAPON_PATH + "MOSH_MagicMissile.png",
		"display_name": "Magic Missile",
		"details": "A trio of homing projectiles are shot at enemies",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"magic_missile2": {
		"icon": WEAPON_PATH + "MOSH_MagicMissile.png",
		"display_name": "Magic Missile",
		"details": "Missiles do more damage",
		"level": "Level: 2",
		"prerequisite": ["magic_missile1"],
		"type": "weapon"
	},
	"magic_missile3": {
		"icon": WEAPON_PATH + "MOSH_MagicMissile.png",
		"display_name": "Magic Missile",
		"details": "Missiles pierce two additional enemies",
		"level": "Level: 3",
		"prerequisite": ["magic_missile2"],
		"type": "weapon"
	},
	"magic_missile4": {
		"icon": WEAPON_PATH + "MOSH_MagicMissile.png",
		"display_name": "Magic Missile",
		"details": "Even more missiles which deal even more damage and move significantly faster",
		"level": "Level: 4",
		"prerequisite": ["magic_missile3"],
		"type": "weapon"
	},
	"javelin1": {
		"icon": WEAPON_PATH + "MOSH_Javelin.png",
		"display_name": "Javelin",
		"details": "A magical javelin will follow you attacking enemies in a straight line",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"javelin2": {
		"icon": WEAPON_PATH + "MOSH_Javelin.png",
		"display_name": "Javelin",
		"details": "The javelin will now attack an additional enemy per attack",
		"level": "Level: 2",
		"prerequisite": ["javelin1"],
		"type": "weapon"
	},
	"javelin3": {
		"icon": WEAPON_PATH + "MOSH_Javelin.png",
		"display_name": "Javelin",
		"details": "The javelin will attack another additional enemy per attack",
		"level": "Level: 3",
		"prerequisite": ["javelin2"],
		"type": "weapon"
	},
	"javelin4": {
		"icon": WEAPON_PATH + "MOSH_Javelin.png",
		"display_name": "Javelin",
		"details": "The javelin now does + 5 damage per attack and causes 20% additional knockback",
		"level": "Level: 4",
		"prerequisite": ["javelin3"],
		"type": "weapon"
	},
	"tornado1": {
		"icon": WEAPON_PATH + "MOSH_Tornado.png",
		"display_name": "Tornado",
		"details": "A tornado is created and random heads somewhere in the players direction",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"tornado2": {
		"icon": WEAPON_PATH + "MOSH_Tornado.png",
		"display_name": "Tornado",
		"details": "An additional Tornado is created",
		"level": "Level: 2",
		"prerequisite": ["tornado1"],
		"type": "weapon"
	},
	"tornado3": {
		"icon": WEAPON_PATH + "MOSH_Tornado.png",
		"display_name": "Tornado",
		"details": "The Tornado cooldown is reduced by 0.5 seconds",
		"level": "Level: 3",
		"prerequisite": ["tornado2"],
		"type": "weapon"
	},
	"tornado4": {
		"icon": WEAPON_PATH + "MOSH_Tornado.png",
		"display_name": "Tornado",
		"details": "An additional tornado is created and the knockback is increased by 25%",
		"level": "Level: 4",
		"prerequisite": ["tornado3"],
		"type": "weapon"
	},
	"armor1": {
		"icon": ICON_PATH + "helmet.png",
		"display_name": "Armor",
		"details": "Reduces Damage By 1 point",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": ICON_PATH + "helmet.png",
		"display_name": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 2",
		"prerequisite": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": ICON_PATH + "helmet.png",
		"display_name": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 3",
		"prerequisite": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": ICON_PATH + "helmet.png",
		"display_name": "Armor",
		"details": "Reduces Damage By an additional 1 point",
		"level": "Level: 4",
		"prerequisite": ["armor3"],
		"type": "upgrade"
	},
	"speed1": {
		"icon": ICON_PATH + "boots.png",
		"display_name": "Speed",
		"details": "Movement Speed Increased by 50% of base speed",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"speed2": {
		"icon": ICON_PATH + "boots.png",
		"display_name": "Speed",
		"details": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 2",
		"prerequisite": ["speed1"],
		"type": "upgrade"
	},
	"speed3": {
		"icon": ICON_PATH + "boots.png",
		"display_name": "Speed",
		"details": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 3",
		"prerequisite": ["speed2"],
		"type": "upgrade"
	},
	"speed4": {
		"icon": ICON_PATH + "boots.png",
		"display_name": "Speed",
		"details": "Movement Speed Increased an additional 50% of base speed",
		"level": "Level: 4",
		"prerequisite": ["speed3"],
		"type": "upgrade"
	},
	"tome1": {
		"icon": ICON_PATH + "tome.png",
		"display_name": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"tome2": {
		"icon": ICON_PATH + "tome.png",
		"display_name": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 2",
		"prerequisite": ["tome1"],
		"type": "upgrade"
	},
	"tome3": {
		"icon": ICON_PATH + "tome.png",
		"display_name": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 3",
		"prerequisite": ["tome2"],
		"type": "upgrade"
	},
	"tome4": {
		"icon": ICON_PATH + "tome.png",
		"display_name": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 4",
		"prerequisite": ["tome3"],
		"type": "upgrade"
	},
	"scroll1": {
		"icon": ICON_PATH + "scroll.png",
		"display_name": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"scroll2": {
		"icon": ICON_PATH + "scroll.png",
		"display_name": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 2",
		"prerequisite": ["scroll1"],
		"type": "upgrade"
	},
	"scroll3": {
		"icon": ICON_PATH + "scroll.png",
		"display_name": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 3",
		"prerequisite": ["scroll2"],
		"type": "upgrade"
	},
	"scroll4": {
		"icon": ICON_PATH + "scroll.png",
		"display_name": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 4",
		"prerequisite": ["scroll3"],
		"type": "upgrade"
	},
	"ring1": {
		"icon": ICON_PATH + "ring.png",
		"display_name": "Ring",
		"details": "Your spells now spawn 1 more additional attack",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"ring2": {
		"icon": ICON_PATH + "ring.png",
		"display_name": "Ring",
		"details": "Your spells now spawn an additional attack",
		"level": "Level: 2",
		"prerequisite": ["ring1"],
		"type": "upgrade"
	},
	"food": {
		"icon": ICON_PATH + "food.png",
		"display_name": "Food",
		"details": "Heals you for 20 health",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
}
 
