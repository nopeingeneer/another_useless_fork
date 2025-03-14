/obj/item/tome
	name = "arcane tome"
	desc = "An old, dusty tome with frayed edges and a sinister-looking cover."
	icon_state ="tome"
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL

/obj/item/tome/traitor
	var/spent = FALSE

/obj/item/tome/traitor/check_uplink_validity()
	return !spent

/obj/item/tome/traitor/attack_self(mob/living/user)
	if(!iscultist(user) && !spent)
		to_chat(user, "<span class='userdanger'>You press your hand onto [src], sinister tendrils of corrupted magic swirling around you. Was this the best of ideas?</span>")
		if(user.mind.add_antag_datum(/datum/antagonist/cult/neutered/traitor))
			spent = TRUE
		else
			to_chat(user, "<span class='userdanger'>[src] falls dark. It appears you weren't worthy.</span>")
	return ..()

/obj/item/melee/cultblade/dagger
	name = "ritual dagger"
	desc = "A strange dagger said to be used by sinister groups for \"preparing\" a corpse before sacrificing it to their dark gods."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	item_state = "cultdagger"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	w_class = WEIGHT_CLASS_SMALL
	force = 15
	throwforce = 25
	wound_bonus = 10
	bare_wound_bonus = 20
	armour_penetration = 35
	actions_types = list(/datum/action/item_action/cult_dagger)

/obj/item/melee/cultblade/dagger/Initialize(mapload)
	. = ..()
	var/image/I = image(icon = 'icons/effects/blood.dmi' , icon_state = null, loc = src)
	I.override = TRUE
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/silicons, "cult_dagger", I)

/obj/item/melee/cultblade
	name = "eldritch longsword"
	desc = "A sword humming with unholy energy. It glows with a dim red light."
	icon_state = "cultblade"
	item_state = "cultblade"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	flags_1 = CONDUCT_1
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_BULKY
	force = 30 // whoever balanced this got beat in the head by a bible too many times good lord
	throwforce = 10
	wound_bonus = 20
	bare_wound_bonus = 15
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "rended")

/obj/item/melee/cultblade/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, 40, 100)
	AddElement(/datum/element/sword_point)

/obj/item/melee/cultblade/attack(mob/living/target, mob/living/carbon/human/user)
	if(!iscultist(user))
		user.DefaultCombatKnockdown(100)
		user.dropItemToGround(src, TRUE)
		user.visible_message("<span class='warning'>A powerful force shoves [user] away from [target]!</span>", \
							"<span class='cultlarge'>\"You shouldn't play with sharp things. You'll poke someone's eye out.\"</span>")
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(rand(force/2, force), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			user.adjustBruteLoss(rand(force/2,force))
		return
	..()

/obj/item/melee/cultblade/ghost
	name = "eldritch sword"
	force = 19 //can't break normal airlocks
	item_flags = NEEDS_PERMIT | DROPDEL
	flags_1 = NONE

/obj/item/melee/cultblade/ghost/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CULT_TRAIT)


/obj/item/melee/cultblade/pickup(mob/living/carbon/human/user)
	..()
	if(!iscultist(user))
		if(!is_servant_of_ratvar(user))
			to_chat(user, "<span class='cultlarge'>\"I wouldn't advise that.\"</span>")
			return
		else
			to_chat(user, "<span class='cultlarge'>\"One of Ratvar's toys is trying to play with things [user.ru_who()] shouldn't. Cute.\"</span>")
			to_chat(user, "<span class='userdanger'>A horrible force yanks at your arm!</span>")
			user.emote("realagony")
			user.apply_damage(30, BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))

/obj/item/cult_bastard
	name = "Bloody Bastard Sword"
	desc = "An enormous sword used by Nar'Sien cultists to rapidly harvest the souls of non-believers."
	w_class = WEIGHT_CLASS_HUGE
	block_chance = 50
	throwforce = 20
	force = 35
	armour_penetration = 45
	throw_speed = 1
	throw_range = 3
	sharpness = SHARP_EDGED
	light_color = "#ff0000"
	attack_verb = list("cleaved", "slashed", "torn", "hacked", "ripped", "diced", "carved")
	icon_state = "cultbastard"
	item_state = "cultbastard"
	hitsound = 'sound/weapons/bladeslice.ogg'
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	actions_types = list()
	var/datum/action/innate/dash/cult/jaunt
	var/datum/action/innate/cult/spin2win/linked_action
	var/spinning = FALSE
	var/spin_cooldown = 250
	var/dash_toggled = TRUE

/obj/item/cult_bastard/Initialize(mapload)
	. = ..()
	set_light(4)
	jaunt = new(src)
	linked_action = new(src)

/obj/item/cult_bastard/Destroy()
	QDEL_NULL(jaunt)
	QDEL_NULL(linked_action)
	. = ..()

/obj/item/cult_bastard/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 50, 80)
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)

/obj/item/cult_bastard/examine(mob/user)
	. = ..()
	if(contents.len)
		. += "<br><b>There are [contents.len] souls trapped within the sword's core.</b>"
	else
		. += "<br>The sword appears to be quite lifeless."

/obj/item/cult_bastard/can_be_pulled(user)
	return FALSE

/obj/item/cult_bastard/attack_self(mob/user)
	dash_toggled = !dash_toggled
	if(dash_toggled)
		to_chat(loc, "<span class='notice'>Ты готовишься к совершению рывка при помощи [src].</span>")
		balloon_alert_to_viewers("[user] готовится к совершению рывка!")
	else
		to_chat(loc, "<span class='notice'>Ты больше не готовишься к совершению рывка при помощи [src].</span>")
		balloon_alert_to_viewers("[user] больше не готовится к совершению рывка!")

/obj/item/cult_bastard/pickup(mob/living/carbon/human/user)
	. = ..()
	if(!iscultist(user))
		if(!is_servant_of_ratvar(user))
			to_chat(user, "<span class='cultlarge'>\"I wouldn't advise that.\"</span>")
			return
		else
			to_chat(user, "<span class='cultlarge'>\"One of Ratvar's toys is trying to play with things [user.ru_who()] shouldn't. Cute.\"</span>")
			to_chat(user, "<span class='userdanger'>A horrible force yanks at your arm!</span>")
			user.apply_damage(30, BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
			user.emote("realagony")
			user.DefaultCombatKnockdown(50)
			return
	force = initial(force)
	jaunt.Grant(user, src)
	linked_action.Grant(user, src)
	user.update_icons()

/obj/item/cult_bastard/attack(mob/living/target, mob/living/carbon/human/user)
	if(!iscultist(user))
		user.DefaultCombatKnockdown(100)
		user.dropItemToGround(src, TRUE)
		user.emote("realagony")
		user.visible_message("<span class='warning'>A powerful force shoves [user] away from [target]!</span>", \
							"<span class='cultlarge'>\"You shouldn't play with sharp things. You'll poke someone's eye out.\"</span>")
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(rand(force/2, force), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			user.adjustBruteLoss(rand(force/2,force))
		return
	..()

/obj/item/cult_bastard/dropped(mob/user)
	. = ..()
	linked_action.Remove(user)
	jaunt.Remove(user)
	user.update_icons()

/obj/item/cult_bastard/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(spinning && is_energy_reflectable_projectile(object) && (attack_type & ATTACK_TYPE_PROJECTILE))
		playsound(src, pick('sound/weapons/effects/ric1.ogg', 'sound/weapons/effects/ric2.ogg', 'sound/weapons/effects/ric3.ogg', 'sound/weapons/effects/ric4.ogg', 'sound/weapons/effects/ric5.ogg'), 100, 1)
		return BLOCK_SUCCESS | BLOCK_PHYSICAL_EXTERNAL | BLOCK_REDIRECTED | BLOCK_SHOULD_REDIRECT
	if(prob(final_block_chance))
		if(attack_type & ATTACK_TYPE_PROJECTILE)
			owner.visible_message("<span class='danger'>[owner] deflects [attack_text] with [src]!</span>")
			playsound(src, pick('sound/weapons/effects/ric1.ogg', 'sound/weapons/effects/ric2.ogg', 'sound/weapons/effects/ric3.ogg', 'sound/weapons/effects/ric4.ogg', 'sound/weapons/effects/ric5.ogg'), 100, 1)
			return BLOCK_SUCCESS | BLOCK_PHYSICAL_EXTERNAL | BLOCK_REDIRECTED | BLOCK_SHOULD_REDIRECT
		else
			playsound(src, 'sound/weapons/parry.ogg', 75, 1)
			owner.visible_message("<span class='danger'>[owner] parries [attack_text] with [src]!</span>")
			return BLOCK_SUCCESS | BLOCK_PHYSICAL_EXTERNAL
	return BLOCK_NONE

/obj/item/cult_bastard/afterattack(atom/target, mob/user, proximity, click_parameters)
	. = ..()
	if(dash_toggled && !proximity)
		jaunt.Teleport(user, target)
		return
	if(proximity)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(H.stat != CONSCIOUS)
				var/obj/item/soulstone/SS = new /obj/item/soulstone(src)
				SS.attack(H, user)
				if(!LAZYLEN(SS.contents))
					qdel(SS)
		if(istype(target, /obj/structure/constructshell) && contents.len)
			var/obj/item/soulstone/SS = contents[1]
			if(istype(SS))
				SS.transfer_soul("CONSTRUCT",target,user)
				qdel(SS)

/datum/action/innate/dash/cult
	name = "Rend the Veil"
	desc = "Use the sword to shear open the flimsy fabric of this reality and teleport to your target."
	icon_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "phaseshift"
	dash_sound = 'sound/magic/enter_blood.ogg'
	recharge_sound = 'sound/magic/exit_blood.ogg'
	beam_effect = "sendbeam"
	phasein = /obj/effect/temp_visual/dir_setting/cult/phase
	phaseout = /obj/effect/temp_visual/dir_setting/cult/phase/out

/datum/action/innate/dash/cult/IsAvailable(silent = FALSE)
	if(iscultist(owner) && current_charges)
		return TRUE
	else
		return FALSE

/datum/action/innate/cult/spin2win
	name = "Geometer's Fury"
	desc = "You draw on the power of the sword's ancient runes, spinning it wildly around you as you become immune to most attacks."
	background_icon_state = "bg_demon"
	button_icon_state = "sintouch"
	var/cooldown = 0
	var/mob/living/carbon/human/holder
	var/obj/item/cult_bastard/sword

/datum/action/innate/cult/spin2win/Grant(mob/user, obj/bastard)
	. = ..()
	sword = bastard
	holder = user

/datum/action/innate/cult/spin2win/IsAvailable(silent = FALSE)
	if(iscultist(holder) && cooldown <= world.time)
		return TRUE
	else
		return FALSE

/datum/action/innate/cult/spin2win/Activate()
	cooldown = world.time + sword.spin_cooldown
	holder.DelayNextAction(50)
	holder.apply_status_effect(/datum/status_effect/sword_spin)
	sword.spinning = TRUE
	sword.block_chance = 100
	sword.slowdown += 1.5
	addtimer(CALLBACK(src, PROC_REF(stop_spinning)), 50)
	holder.update_action_buttons_icon()

/datum/action/innate/cult/spin2win/proc/stop_spinning()
	sword.spinning = FALSE
	sword.block_chance = 50
	sword.slowdown -= 1.5
	sleep(sword.spin_cooldown)
	holder.update_action_buttons_icon()

/obj/item/restraints/legcuffs/bola/cult
	name = "\improper Nar'Sien bola"
	desc = "A strong bola, bound with dark magic that allows it to pass harmlessly through Nar'Sien cultists. Throw it to trip and slow your victim."
	icon_state = "bola_cult"
	breakouttime = 60
	knockdown = 20

/obj/item/restraints/legcuffs/bola/cult/pickup(mob/living/user)
	. = ..()
	if(!iscultist(user))
		to_chat(user, "<span class='warning'>The bola seems to take on a life of its own!</span>")
		ensnare(user)

/obj/item/restraints/legcuffs/bola/cult/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(iscultist(hit_atom))
		return
	. = ..()

/obj/item/clothing/head/culthood
	name = "ancient cultist hood"
	icon_state = "culthood"
	desc = "A torn, dust-caked hood. Strange letters line the inside."
	flags_inv = HIDEFACE|HIDEHAIR|HIDEEARS
	flags_cover = HEADCOVERSEYES
	armor = list(MELEE = 40, BULLET = 30, LASER = 40,ENERGY = 20, BOMB = 65, BIO = 10, RAD = 0, FIRE = 10, ACID = 10)
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT
	alternate_screams = BLOOD_SCREAMS

/obj/item/clothing/suit/cultrobes
	name = "ancient cultist robes"
	desc = "A ragged, dusty set of robes. Strange letters line the inside."
	icon_state = "cultrobes"
	item_state = "cultrobes"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	allowed = list(/obj/item/tome, /obj/item/melee/cultblade)
	armor = list(MELEE = 40, BULLET = 30, LASER = 40,ENERGY = 20, BOMB = 65, BIO = 10, RAD = 0, FIRE = 10, ACID = 10)
	flags_inv = HIDEJUMPSUIT
	cold_protection = CHEST|GROIN|LEGS|ARMS
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|ARMS
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	alternate_screams = BLOOD_SCREAMS
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_SNEK_TAURIC //bluemoon add

/obj/item/clothing/head/culthood/alt
	name = "cultist hood"
	desc = "An armored hood worn by the followers of Nar'Sie."
	icon_state = "cult_hoodalt"
	item_state = "cult_hoodalt"
	dynamic_hair_suffix = ""

/obj/item/clothing/head/culthood/alt/ghost
	item_flags = DROPDEL

/obj/item/clothing/head/culthood/alt/ghost/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CULT_TRAIT)


/obj/item/clothing/suit/cultrobes/alt
	name = "cultist robes"
	desc = "An armored set of robes worn by the followers of Nar'Sie."
	icon_state = "cultrobesalt"
	item_state = "cultrobesalt"

/obj/item/clothing/suit/cultrobes/alt/ghost
	item_flags = DROPDEL

/obj/item/clothing/suit/cultrobes/alt/ghost/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CULT_TRAIT)

/obj/item/clothing/head/magus
	name = "magus helm"
	icon_state = "magus"
	item_state = "magus"
	desc = "A helm worn by the followers of Nar'Sie."
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDEEARS|HIDEEYES|HIDESNOUT
	armor = list(MELEE = 30, BULLET = 30, LASER = 30,ENERGY = 20, BOMB = 0, BIO = 0, RAD = 0, FIRE = 10, ACID = 10)
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	mutantrace_variation = STYLE_MUZZLE
	alternate_screams = BLOOD_SCREAMS

/obj/item/clothing/suit/magusred
	name = "magus robes"
	desc = "A set of armored robes worn by the followers of Nar'Sie."
	icon_state = "magusred"
	item_state = "magusred"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	allowed = list(/obj/item/tome, /obj/item/melee/cultblade)
	armor = list(MELEE = 50, BULLET = 30, LASER = 50,ENERGY = 20, BOMB = 25, BIO = 10, RAD = 0, FIRE = 10, ACID = 10)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	alternate_screams = BLOOD_SCREAMS

/obj/item/clothing/head/helmet/space/hardsuit/cult
	name = "\improper Nar'Sien hardened helmet"
	desc = "A heavily-armored helmet worn by warriors of the Nar'Sien cult. It can withstand hard vacuum."
	icon_state = "cult_helmet"
	item_state = "cult_helmet"
	armor = list(MELEE = 60, BULLET = 50, LASER = 30,ENERGY = 15, BOMB = 30, BIO = 30, RAD = 30, FIRE = 100, ACID = 75)
	brightness_on = 0
	actions_types = list()
	alternate_screams = BLOOD_SCREAMS


/obj/item/clothing/head/helmet/space/hardsuit/cult/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/spellcasting, SPELL_CULT_HELMET, ITEM_SLOT_HEAD)

/obj/item/clothing/suit/space/hardsuit/cult
	name = "\improper Nar'Sien Hardened Armor"
	icon_state = "cult_armor"
	item_state = "cult_armor"
	tail_state = "syndicate-blood"
	desc = "A heavily-armored exosuit worn by warriors of the Nar'Sien cult. It can withstand hard vacuum."
	w_class = WEIGHT_CLASS_BULKY
	allowed = list(/obj/item/tome, /obj/item/melee/cultblade, /obj/item/tank/internals/)
	armor = list(MELEE = 70, BULLET = 50, LASER = 30,ENERGY = 15, BOMB = 30, BIO = 30, RAD = 30, FIRE = 100, ACID = 75)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/cult
	alternate_screams = BLOOD_SCREAMS

/obj/item/clothing/suit/space/hardsuit/cult/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/spellcasting, SPELL_CULT_ARMOR, ITEM_SLOT_OCLOTHING)

/obj/item/sharpener/cult
	name = "eldritch whetstone"
	desc = "A block, empowered by dark magic. Sharp weapons will be enhanced when used on the stone."
	icon_state = "cult_sharpener"
	used = 0
	increment = 5
	max = 40
	prefix = "darkened"

/obj/item/sharpener/cult/update_icon_state()
	var/old_state = icon_state
	icon_state = "cult_sharpener[used ? "_used" : ""]"
	if(old_state != icon_state)
		playsound(get_turf(src), 'sound/items/unsheath.ogg', 25, 1)

/obj/item/clothing/suit/hooded/cultrobes/cult_shield
	name = "\improper Nar'Sien Empowered Armor"
	desc = "A heavily-armored Empowered Exosuit worn by warriors of the Nar'Sien cult. It can withstand hard vacuum and creates a powerful shield around the user."
	icon_state = "cult_armor"
	item_state = "cult_armor"
	w_class = WEIGHT_CLASS_BULKY
	armor = list(MELEE = 50, BULLET = 40, LASER = 50, ENERGY = 60, BOMB = 50, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, MAGIC = 75)
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	allowed = list(/obj/item/tome, /obj/item/melee/cultblade)
	var/current_charges = 3
	hoodtype = /obj/item/clothing/head/hooded/cult_hoodie
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | ALLOWINTERNALS
	alternate_screams = BLOOD_SCREAMS
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_SNEK_TAURIC //bluemoon add

/obj/item/clothing/head/hooded/cult_hoodie
	name = "\improper Nar'Sien Empowered Helmet"
	desc = "A heavily-armored Empowered Helmet worn by warriors of the Nar'Sien cult. It can withstand hard vacuum."
	icon_state = "cult_hoodalt"
	armor = list(MELEE = 50, BULLET = 40, LASER = 50, ENERGY = 60, BOMB = 50, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, MAGIC = 75)
	body_parts_covered = HEAD
	flash_protect = 1
	flags_inv = HIDEHAIR|HIDEFACE|HIDEEARS
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | ALLOWINTERNALS
	alternate_screams = BLOOD_SCREAMS

/obj/item/clothing/suit/hooded/cultrobes/cult_shield/equipped(mob/living/user, slot)
	..()
	if(!iscultist(user))
		if(!is_servant_of_ratvar(user))
			to_chat(user, "<span class='cultlarge'>\"I wouldn't advise that.\"</span>")
			to_chat(user, "<span class='warning'>An overwhelming sense of nausea overpowers you!</span>")
			user.dropItemToGround(src, TRUE)
			user.Dizzy(30)
			user.DefaultCombatKnockdown(100)
		else
			to_chat(user, "<span class='cultlarge'>\"Trying to use things you don't own is bad, you know.\"</span>")
			to_chat(user, "<span class='userdanger'>The armor squeezes at your body!</span>")
			user.emote("realagony")
			user.adjustBruteLoss(25)
			user.dropItemToGround(src, TRUE)

/obj/item/clothing/suit/hooded/cultrobes/cult_shield/check_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(current_charges)
		block_return[BLOCK_RETURN_NORMAL_BLOCK_CHANCE] = 100
		block_return[BLOCK_RETURN_BLOCK_CAPACITY] = (block_return[BLOCK_RETURN_BLOCK_CAPACITY] || 0) + current_charges
	return ..()

/obj/item/clothing/suit/hooded/cultrobes/cult_shield/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(current_charges)
		owner.visible_message("<span class='danger'>\The [attack_text] is deflected in a burst of blood-red sparks!</span>")
		current_charges--
		new /obj/effect/temp_visual/cult/sparks(get_turf(owner))
		if(!current_charges)
			owner.visible_message("<span class='danger'>The runed shield around [owner] suddenly disappears!</span>")
			owner.update_inv_wear_suit()
		return BLOCK_SUCCESS | BLOCK_PHYSICAL_EXTERNAL
	return BLOCK_NONE

/obj/item/clothing/suit/hooded/cultrobes/cult_shield/worn_overlays(isinhands, icon_file, used_state, style_flags = NONE)
	. = ..()
	if(!isinhands && current_charges)
		. += mutable_appearance('icons/effects/cult_effects.dmi', "shield-cult", MOB_LAYER + 0.01)

/obj/item/clothing/suit/hooded/cultrobes/berserker
	name = "Flagellant's Robes"
	desc = "Blood-soaked robes infused with dark magic; allows the user to move at inhuman speeds, but at the cost of increased damage."
	icon_state = "cultrobes"
	item_state = "cultrobes"
	flags_inv = HIDEJUMPSUIT
	allowed = list(/obj/item/tome, /obj/item/melee/cultblade)
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	armor = list(MELEE = -50, BULLET = -50, LASER = -50,ENERGY = -50, BOMB = -50, BIO = -50, RAD = -50, FIRE = 0, ACID = 0)
	slowdown = -1
	hoodtype = /obj/item/clothing/head/hooded/berserkerhood
	mutantrace_variation = STYLE_DIGITIGRADE|STYLE_SNEK_TAURIC //bluemoon add

/obj/item/clothing/head/hooded/berserkerhood
	name = "Flagellant's Robes"
	desc = "Blood-soaked garb infused with dark magic; allows the user to move at inhuman speeds, but at the cost of increased damage."
	icon_state = "culthood"
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEFACE|HIDEEARS
	armor = list(MELEE = -50, BULLET = -50, LASER = -50, ENERGY = -50, BOMB = -50, BIO = -50, RAD = -50, FIRE = 0, ACID = 0)
	alternate_screams = BLOOD_SCREAMS

/obj/item/clothing/suit/hooded/cultrobes/berserker/equipped(mob/living/user, slot)
	..()
	if(!iscultist(user))
		if(!is_servant_of_ratvar(user))
			to_chat(user, "<span class='cultlarge'>\"I wouldn't advise that.\"</span>")
			to_chat(user, "<span class='warning'>An overwhelming sense of nausea overpowers you!</span>")
			user.dropItemToGround(src, TRUE)
			user.Dizzy(30)
			user.DefaultCombatKnockdown(100)
		else
			to_chat(user, "<span class='cultlarge'>\"Trying to use things you don't own is bad, you know.\"</span>")
			to_chat(user, "<span class='userdanger'>The robes squeeze at your body!</span>")
			user.emote("realagony")
			user.adjustBruteLoss(25)
			user.dropItemToGround(src, TRUE)

/obj/item/clothing/glasses/hud/health/night/cultblind
	desc = "may Nar'Sie guide you through the darkness and shield you from the light."
	name = "zealot's blindfold"
	icon_state = "blindfold"
	item_state = "blindfold"
	flash_protect = 1
	invis_override = SEE_INVISIBLE_HIDDEN_RUNES

/obj/item/clothing/glasses/hud/health/night/cultblind/equipped(mob/living/user, slot)
	..()
	if(!iscultist(user))
		to_chat(user, "<span class='cultlarge'>\"You want to be blind, do you?\"</span>")
		user.emote("realagony")
		user.dropItemToGround(src, TRUE)
		user.Dizzy(30)
		user.DefaultCombatKnockdown(100)
		user.blind_eyes(30)

/obj/item/reagent_containers/glass/beaker/unholywater
	name = "flask of unholy water"
	desc = "Toxic to nonbelievers; reinvigorating to the faithful - this flask may be sipped or thrown."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "holyflask"
	color = "#333333"
	list_reagents = list(/datum/reagent/fuel/unholywater = 50)

/obj/item/shuttle_curse
	name = "Проклятая Сфера"
	desc = "You peer within this smokey orb and glimpse terrible fates befalling the escape shuttle."
	icon = 'icons/obj/cult.dmi'
	icon_state ="shuttlecurse"
	var/static/curselimit = 0

/obj/item/shuttle_curse/attack_self(mob/living/user)
	if(!iscultist(user, TRUE))
		user.dropItemToGround(src, TRUE)
		user.DefaultCombatKnockdown(100)
		user.emote("realagony")
		to_chat(user, "<span class='warning'>Мощная сила отталкивает вас от [src]!</span>")
		return
	if(curselimit > 1)
		to_chat(user, "<span class='notice'>Мы исчерпали свою способность проклинать Космическую Станцию.</span>")
		return
	if(locate(/obj/singularity/narsie) in GLOB.poi_list)
		to_chat(user, "<span class='warning'>Nar'Sie is already on this plane, there is no delaying the end of all things.</span>")
		return

	if(SSshuttle.emergency.mode == SHUTTLE_CALL)
		var/cursetime = 1800
		var/timer = SSshuttle.emergency.timeLeft(1) + cursetime
		var/security_num = SECLEVEL2NUM(NUM2SECLEVEL(GLOB.security_level))
		var/set_coefficient = 1
		switch(security_num)
			if(SEC_LEVEL_GREEN)
				set_coefficient = 2
			if(SEC_LEVEL_BLUE)
				set_coefficient = 1.2
			if(SEC_LEVEL_AMBER)
				set_coefficient = 0.8
			else
				set_coefficient = 0.5
		var/surplus = timer - (SSshuttle.emergencyCallTime * set_coefficient)
		SSshuttle.emergency.setTimer(timer)
		if(surplus > 0)
			SSshuttle.block_recall(surplus)
		to_chat(user, "<span class='danger'>Вы разбиваете сферу! Темная сущность поднимается в воздух, затем исчезает.</span>")
		playsound(user.loc, 'sound/effects/glassbr1.ogg', 50, 1)
		qdel(src)
		sleep(20)
		var/static/list/curses
		if(!curses)
			curses = list("Специалист по Заправке Шаттлов только что перерезал себе горло, умоляя о смерти",
			"Навигационная программа шаттла была заменена файлом, содержащим всего два слова: ОНА ИДЁТ.",
			"Смотритель Шаттла Эвакуации был найден в Диспетчерской, моющий окна собственной кровью.",
			"Инженер шаттла начала кричать 'СМЕРТЬ - НЕ КОНЕЦ' и вырвала провода, пока вспышка дуги не сожгла ее плоть.",
			"Безумная Инспектор начала смеяться по радио, а затем бросилась в турбину двигателя...",
			"На шаттле был найден... АССИСТЕНТ!",
			"Сотрудник Медицинского Блока был найден на мостике шаттла с множеством пустых пакетов крови. Он замкнул проводку Консолей этой субстанцией и зачем добавил своей крови, вскрикнув 'СМЕРТЬ - НЕ КОНЕЦ'",
			"Специалист по Заправке Шаттлов был найден заменяющим топливо своей кровью...",
			"Все лампы на борту шаттла стали багрово-красными, а затем погасли... нам нужно время разобраться с этим...",
			"Диспетчер был найден мертвым... прямо на его плоти были вырезаны кровавые символы.",
			"Из турбины Двигателя хлынул огромный поток крови и нам нужно... время...",
			"Транспондер шаттла излучает закодированное сообщение 'ОНО ИДЁТ' вместо положенного идентификационного сигнала.")
		var/message = pick_n_take(curses)
		message += " Шаттл будет задержан на три минуты."
		priority_announce("[message]", "Центральное Командование, Отдел Работы с Реальностью", 'sound/announcer/classic/delay.ogg')
		curselimit++

/obj/item/station_curse
	name = "Проклятая Сфера"
	desc = "Эта сфера хранит в себе первородное зло и, наверное, это недопустимо ронять или даже ломать..."
	icon = 'icons/obj/cult.dmi'
	icon_state ="shuttlecurse"
	var/static/curselimit = 0

/obj/item/station_curse/attack_self(mob/living/user)
	if(!iscultist(user, TRUE))
		user.dropItemToGround(src, TRUE)
		user.DefaultCombatKnockdown(100)
		user.emote("realagony")
		to_chat(user, "<span class='warning'>Мощная сила отталкивает вас от [src]!</span>")
		return
	if(curselimit >= 2)
		to_chat(user, "<span class='notice'>Мы исчерпали свою способность проклинать Космическую Станцию.</span>")
		return
	if(locate(/obj/singularity/narsie) in GLOB.poi_list)
		to_chat(user, "<span class='warning'>Nar'Sie is already on this plane, there is no delaying the end of all things.</span>")
		return

	to_chat(user, "<span class='danger'>Вы разбиваете сферу! Темная сущность поднимается в воздух, затем исчезает.</span>")
	playsound(user.loc, 'sound/effects/glassbr1.ogg', 50, 1)
	qdel(src)
	sleep(pick(50, 100, 150, 200, 250))
	var/datum/round_event_control/portal_storm_narsie/portal_storm_narsie = new/datum/round_event_control/portal_storm_narsie
	portal_storm_narsie.runEvent()
	curselimit++

/obj/item/cult_shift
	name = "Veil Shifter"
	desc = "This relic instantly teleports you, and anything you're pulling, forward by a moderate distance."
	icon = 'icons/obj/cult.dmi'
	icon_state ="shifter"
	var/uses = 4

/obj/item/cult_shift/examine(mob/user)
	. = ..()
	if(uses)
		. += "<span class='cult'>It has [uses] use\s remaining.</span>"
	else
		. += "<span class='cult'>It seems drained.</span>"

/obj/item/cult_shift/proc/handle_teleport_grab(turf/T, mob/user)
	var/mob/living/carbon/C = user
	if(C.pulling)
		var/atom/movable/pulled = C.pulling
		do_teleport(pulled, T, channel = TELEPORT_CHANNEL_CULT)
		. = pulled

/obj/item/cult_shift/attack_self(mob/living/carbon/human/user)
	if(!uses || !iscarbon(user))
		to_chat(user, "<span class='warning'>\The [src] is dull and unmoving in your hands.</span>")
		return
	if(!iscultist(user))
		user.dropItemToGround(src, TRUE)
		user.Dizzy(30)
		user.DefaultCombatKnockdown(100)
		user.emote("realagony")
		step(src, pick(GLOB.alldirs))
		to_chat(user, "<span class='warning'>\The [src] flickers out of your hands, your connection to this dimension is too strong!</span>")
		return

	var/mob/living/carbon/C = user
	var/turf/mobloc = get_turf(C)
	var/turf/destination = get_teleport_loc(location = mobloc, target = C, distance = 9, density_check = TRUE, errorx = 3, errory = 1, eoffsety = 1)

	if(destination)
		uses--
		if(uses <= 0)
			icon_state ="shifter_drained"
		playsound(mobloc, "sparks", 50, 1)
		new /obj/effect/temp_visual/dir_setting/cult/phase/out(mobloc, C.dir)

		var/atom/movable/pulled = handle_teleport_grab(destination, C)
		if(do_teleport(C, destination, channel = TELEPORT_CHANNEL_CULT))
			if(pulled)
				C.start_pulling(pulled) //forcemove resets pulls, so we need to re-pull
			new /obj/effect/temp_visual/dir_setting/cult/phase(destination, C.dir)
			playsound(destination, 'sound/effects/phasein.ogg', 25, 1)
			playsound(destination, "sparks", 50, 1)

	else
		to_chat(C, "<span class='danger'>The veil cannot be torn here!</span>")

/obj/item/flashlight/flare/culttorch
	name = "Void Torch"
	desc = "Used by veteran cultists to instantly transport items to their needful brethren."
	w_class = WEIGHT_CLASS_SMALL
	brightness_on = 1
	icon_state = "torch"
	item_state = "torch"
	color = "#ff0000"
	on_damage = 15
	slot_flags = null
	on = TRUE
	var/charges = 5

/obj/item/flashlight/flare/culttorch/afterattack(atom/movable/A, mob/user, proximity)
	if(!proximity)
		return
	if(!iscultist(user))
		to_chat(user, "That doesn't seem to do anything useful.")
		return

	if(istype(A, /obj/item))
		transmit_item(A, user, proximity)

	else
		..()
		to_chat(user, "<span class='warning'>\The [src] can only transport items!</span>")

/obj/item/flashlight/flare/culttorch/proc/transmit_item(atom/movable/A, mob/user, proximity)
	set waitfor = FALSE
	var/list/cultists = list()
	for(var/datum/mind/M in SSticker.mode.cult)
		if(M.current && M.current.stat != DEAD)
			cultists |= M.current
	var/mob/living/cultist_to_receive = input(user, "Who do you wish to call to [src]?", "Followers of the Geometer") as null|anything in (cultists - user)
	if(!Adjacent(user) || !src || QDELETED(src) || user.incapacitated())
		return
	if(!cultist_to_receive)
		to_chat(user, "<span class='cult italic'>You require a destination!</span>")
		log_game("Void torch failed - no target")
		return
	if(cultist_to_receive.stat == DEAD)
		to_chat(user, "<span class='cult italic'>[cultist_to_receive] has died!</span>")
		log_game("Void torch failed  - target died")
		return
	if(!iscultist(cultist_to_receive))
		to_chat(user, "<span class='cult italic'>[cultist_to_receive] is not a follower of the Geometer!</span>")
		log_game("Void torch failed - target was deconverted")
		return
	if(A in user.GetAllContents())
		to_chat(user, "<span class='cult italic'>[A] must be on a surface in order to teleport it!</span>")
		return
	to_chat(user, "<span class='cult italic'>You ignite [A] with \the [src], turning it to ash, but through the torch's flames you see that [A] has reached [cultist_to_receive]!")
	cultist_to_receive.put_in_hands(A)
	charges--
	to_chat(user, "\The [src] now has [charges] charge\s.")
	if(charges == 0)
		qdel(src)

/obj/item/cult_spear
	name = "Blood Spear"
	desc = "A sickening spear composed entirely of crystallized blood."
	icon_state = "bloodspear0"
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'
	slot_flags = 0
	force = 17
	throwforce = 52
	throw_speed = 2
	armour_penetration = 30
	block_chance = 30
	attack_verb = list("attacked", "impaled", "stabbed", "torn", "gored")
	sharpness = SHARP_EDGED
	hitsound = 'sound/weapons/bladeslice.ogg'
	var/datum/action/innate/cult/spear/spear_act
	var/wielded = FALSE // track wielded status on item

/obj/item/cult_spear/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, PROC_REF(on_wield))
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, PROC_REF(on_unwield))

/obj/item/cult_spear/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 100, 90)
	AddComponent(/datum/component/two_handed, force_unwielded=17, force_wielded=25, icon_wielded="bloodspear1")

/// triggered on wield of two handed item
/obj/item/cult_spear/proc/on_wield(obj/item/source, mob/user)
	wielded = TRUE

/// triggered on unwield of two handed item
/obj/item/cult_spear/proc/on_unwield(obj/item/source, mob/user)
	wielded = FALSE

/obj/item/cult_spear/update_icon_state()
	icon_state = "bloodspear0"

/obj/item/cult_spear/Destroy()
	if(spear_act)
		qdel(spear_act)
	return ..()

/obj/item/cult_spear/attack(mob/living/target, mob/living/carbon/human/user)
	if(!iscultist(user))
		user.DefaultCombatKnockdown(100)
		user.dropItemToGround(src, TRUE)
		user.emote("realagony")
		user.visible_message("<span class='warning'>A powerful force shoves [user] away from [target]!</span>", \
							"<span class='cultlarge'>\"You shouldn't play with sharp things. You'll poke someone's eye out.\"</span>")
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(rand(force/2, force), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			user.adjustBruteLoss(rand(force/2,force))
		return
	..()

/obj/item/cult_spear/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/turf/T = get_turf(hit_atom)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		if(iscultist(L))
			playsound(src, 'sound/weapons/throwtap.ogg', 50)
			if(L.put_in_active_hand(src))
				L.visible_message("<span class='warning'>[L] catches [src] out of the air!</span>")
			else
				L.visible_message("<span class='warning'>[src] bounces off of [L], as if repelled by an unseen force!</span>")
		else if(!..())
			if(!L.anti_magic_check())
				if(is_servant_of_ratvar(L))
					to_chat(L, "<span class='cultlarge'>\"Kneel for me, scum\"</span>")
					L.confused += clamp(10 - L.confused, 0, 5) //confuses and lightly knockdowns + damages hostile cultists instead of hardstunning like before
					L.DefaultCombatKnockdown(15)
					L.adjustBruteLoss(10)
				else
					L.DefaultCombatKnockdown(50)
			break_spear(T)
	else
		..()

/obj/item/cult_spear/proc/break_spear(turf/T)
	if(src)
		if(!T)
			T = get_turf(src)
		if(T)
			T.visible_message("<span class='warning'>[src] shatters and melts back into blood!</span>")
			new /obj/effect/temp_visual/cult/sparks(T)
			new /obj/effect/decal/cleanable/blood/splatter(T)
			playsound(T, 'sound/effects/glassbr3.ogg', 100)
	qdel(src)

/obj/item/cult_spear/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(wielded)
		final_block_chance *= 2
	if(prob(final_block_chance))
		if(attack_type & ATTACK_TYPE_PROJECTILE)
			owner.visible_message("<span class='danger'>[owner] deflects [attack_text] with [src]!</span>")
			playsound(src, pick('sound/weapons/effects/ric1.ogg', 'sound/weapons/effects/ric2.ogg', 'sound/weapons/effects/ric3.ogg', 'sound/weapons/effects/ric4.ogg', 'sound/weapons/effects/ric5.ogg'), 100, 1)
			return BLOCK_SUCCESS | BLOCK_SHOULD_REDIRECT | BLOCK_REDIRECTED | BLOCK_PHYSICAL_EXTERNAL
		else
			playsound(src, 'sound/weapons/parry.ogg', 100, 1)
			owner.visible_message("<span class='danger'>[owner] parries [attack_text] with [src]!</span>")
			return BLOCK_SUCCESS | BLOCK_PHYSICAL_EXTERNAL
	return BLOCK_NONE

/obj/item/cult_halberd
	name = "Blood Halberd"
	desc = "A sickening halberd composed entirely of crystallized blood."
	icon_state = "occultpoleaxe0"
	lefthand_file = 'icons/mob/inhands/weapons/polearms_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/polearms_righthand.dmi'
	slot_flags = 0
	force = 17
	throwforce = 28
	throw_speed = 2
	armour_penetration = 30
	block_chance = 45
	attack_verb = list("attacked", "impaled", "stabbed", "torn", "gored")
	sharpness = SHARP_EDGED
	hitsound = 'sound/weapons/bladeslice.ogg'
	block_parry_data = /datum/block_parry_data/inteq_sledgehammer
	var/datum/action/innate/cult/spear/halberd_act
	var/wielded = FALSE // track wielded status on item


/obj/item/cult_halberd/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, PROC_REF(on_wield))
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, PROC_REF(on_unwield))

/obj/item/cult_halberd/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/butchering, 100, 90)
	AddComponent(/datum/component/two_handed, force_unwielded=17, force_wielded=34, icon_wielded="occultpoleaxe1")

/// triggered on wield of two handed item
/obj/item/cult_halberd/proc/on_wield(obj/item/source, mob/user)
	wielded = TRUE

/// triggered on unwield of two handed item
/obj/item/cult_halberd/proc/on_unwield(obj/item/source, mob/user)
	wielded = FALSE

/obj/item/cult_halberd/update_icon_state()
	icon_state = "occultpoleaxe0"

/obj/item/cult_halberd/Destroy()
	if(halberd_act)
		qdel(halberd_act)
	return ..()

/obj/item/cult_halberd/attack(mob/living/target, mob/living/carbon/human/user)
	if(!iscultist(user))
		user.DefaultCombatKnockdown(100)
		user.dropItemToGround(src, TRUE)
		user.emote("realagony")
		user.visible_message("<span class='warning'>A powerful force shoves [user] away from [target]!</span>", \
							"<span class='cultlarge'>\"You shouldn't play with sharp things. You'll poke someone's eye out.\"</span>")
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(rand(force/2, force), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		else
			user.adjustBruteLoss(rand(force/2,force))
		return
	..()

/obj/item/cult_halberd/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/turf/T = get_turf(hit_atom)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		if(iscultist(L))
			playsound(src, 'sound/weapons/throwtap.ogg', 50)
			if(L.put_in_active_hand(src))
				L.visible_message("<span class='warning'>[L] catches [src] out of the air!</span>")
			else
				L.visible_message("<span class='warning'>[src] bounces off of [L], as if repelled by an unseen force!</span>")
		else if(!..())
			if(!L.anti_magic_check())
				if(is_servant_of_ratvar(L))
					to_chat(L, "<span class='cultlarge'>\"Kneel for me, scum\"</span>")
					L.confused += clamp(10 - L.confused, 0, 5) //confuses and lightly knockdowns + damages hostile cultists instead of hardstunning like before
					L.DefaultCombatKnockdown(15)
					L.adjustBruteLoss(10)
				else
					L.DefaultCombatKnockdown(50)
			break_halberd(T)
	else
		..()

/obj/item/cult_halberd/proc/break_halberd(turf/T)
	if(src)
		if(!T)
			T = get_turf(src)
		if(T)
			T.visible_message("<span class='warning'>[src] shatters and melts back into blood!</span>")
			new /obj/effect/temp_visual/cult/sparks(T)
			new /obj/effect/decal/cleanable/blood/splatter(T)
			playsound(T, 'sound/effects/glassbr3.ogg', 100)
	qdel(src)

/obj/item/cult_halberd/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(wielded)
		final_block_chance *= 2
	if(prob(final_block_chance))
		if(attack_type & ATTACK_TYPE_PROJECTILE)
			owner.visible_message("<span class='danger'>[owner] deflects [attack_text] with [src]!</span>")
			playsound(src, pick('sound/weapons/effects/ric1.ogg', 'sound/weapons/effects/ric2.ogg', 'sound/weapons/effects/ric3.ogg', 'sound/weapons/effects/ric4.ogg', 'sound/weapons/effects/ric5.ogg'), 100, 1)
			return BLOCK_SUCCESS | BLOCK_SHOULD_REDIRECT | BLOCK_REDIRECTED | BLOCK_PHYSICAL_EXTERNAL
		else
			playsound(src, 'sound/weapons/parry.ogg', 100, 1)
			owner.visible_message("<span class='danger'>[owner] parries [attack_text] with [src]!</span>")
			return BLOCK_SUCCESS | BLOCK_PHYSICAL_EXTERNAL
	return BLOCK_NONE

/datum/action/innate/cult/spear
	name = "Bloody Bond"
	desc = "Call the blood spear back to your hand!"
	background_icon_state = "bg_demon"
	button_icon_state = "bloodspear"
	default_button_position = "6:157,4:-2"
	var/obj/item/cult_spear/spear
	var/cooldown = 0

/datum/action/innate/cult/spear/Grant(mob/user, obj/blood_spear)
	. = ..()
	spear = blood_spear

/datum/action/innate/cult/spear/Activate()
	if(owner == spear.loc || cooldown > world.time)
		return
	var/ST = get_turf(spear)
	var/OT = get_turf(owner)
	if(get_dist(OT, ST) > 10)
		to_chat(owner,"<span class='cult'>The spear is too far away!</span>")
	else
		cooldown = world.time + 20
		if(isliving(spear.loc))
			var/mob/living/L = spear.loc
			L.dropItemToGround(spear)
			L.visible_message("<span class='warning'>An unseen force pulls the blood spear from [L]'s hands!</span>")
		spear.throw_at(owner, 10, 2, owner)


/obj/item/gun/ballistic/shotgun/boltaction/enchanted/arcane_barrage/blood
	name = "blood bolt barrage"
	desc = "Blood for blood."
	color = "#ff0000"
	guns_left = 24
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/enchanted/arcane_barrage/blood
	fire_sound = 'sound/magic/wand_teleport.ogg'
	item_flags = NEEDS_PERMIT | NOBLUDGEON | DROPDEL


/obj/item/ammo_box/magazine/internal/boltaction/enchanted/arcane_barrage/blood
	ammo_type = /obj/item/ammo_casing/magic/arcane_barrage/blood

/obj/item/ammo_casing/magic/arcane_barrage/blood
	projectile_type = /obj/item/projectile/magic/arcane_barrage/blood

/obj/item/projectile/magic/arcane_barrage/blood
	name = "blood bolt"
	icon_state = "mini_leaper"
	damage_type = BRUTE
	impact_effect_type = /obj/effect/temp_visual/dir_setting/bloodsplatter

/obj/item/projectile/magic/arcane_barrage/blood/Bump(atom/target)
	var/turf/T = get_turf(target)
	playsound(T, 'sound/effects/splat.ogg', 50, TRUE)
	if(iscultist(target))
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(H.stat != DEAD)
				H.reagents.add_reagent(/datum/reagent/fuel/unholywater, 10)
		if(isshade(target) || isconstruct(target))
			var/mob/living/simple_animal/M = target
			if(M.health+5 < M.maxHealth)
				M.adjustHealth(-25)
		new /obj/effect/temp_visual/cult/sparks(T)
		qdel(src)
	else
		..()

/obj/item/blood_beam
	name = "\improper magical aura"
	desc = "Sinister looking aura that distorts the flow of reality around it."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "disintegrate"
	item_state = null
	item_flags = ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	var/charging = FALSE
	var/firing = FALSE
	var/angle

/obj/item/blood_beam/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CULT_TRAIT)

/obj/item/blood_beam/afterattack(atom/A, mob/living/user, flag, params)
	. = ..()
	if(firing || charging)
		return
	var/C = user.client
	if(ishuman(user) && C)
		angle = mouse_angle_from_client(C)
	else
		qdel(src)
		return
	charging = TRUE
	INVOKE_ASYNC(src, PROC_REF(charge), user)
	if(do_after(user, 90, target = user))
		firing = TRUE
		INVOKE_ASYNC(src, PROC_REF(pewpew), user, params)
		var/obj/structure/emergency_shield/invoker/N = new(user.loc)
		if(do_after(user, 90, target = user))
			user.DefaultCombatKnockdown(40)
			to_chat(user, "<span class='cult italic'>You have exhausted the power of this spell!</span>")
		firing = FALSE
		if(N)
			qdel(N)
		qdel(src)
	charging = FALSE

/obj/item/blood_beam/proc/charge(mob/user)
	var/obj/O
	playsound(src, 'sound/magic/lightning_chargeup.ogg', 100, 1)
	for(var/i in 1 to 12)
		if(!charging)
			break
		if(i > 1)
			sleep(15)
		if(i < 4)
			O = new /obj/effect/temp_visual/cult/rune_spawn/rune1/inner(user.loc, 30, "#ff0000")
		else
			O = new /obj/effect/temp_visual/cult/rune_spawn/rune5(user.loc, 30, "#ff0000")
			new /obj/effect/temp_visual/dir_setting/cult/phase/out(user.loc, user.dir)
	if(O)
		qdel(O)

/obj/item/blood_beam/proc/pewpew(mob/user, params)
	var/turf/targets_from = get_turf(src)
	var/spread = 40
	var/second = FALSE
	var/set_angle = angle
	for(var/i in 1 to 12)
		if(second)
			set_angle = angle - spread
			spread -= 8
		else
			sleep(15)
			set_angle = angle + spread
		second = !second //Handles beam firing in pairs
		if(!firing)
			break
		playsound(src, 'sound/magic/exit_blood.ogg', 75, 1)
		new /obj/effect/temp_visual/dir_setting/cult/phase(user.loc, user.dir)
		var/turf/temp_target = get_turf_in_angle(set_angle, targets_from, 40)
		for(var/turf/T in getline(targets_from,temp_target))
			if (locate(/obj/effect/blessing, T))
				temp_target = T
				playsound(T, 'sound/machines/clockcult/ark_damage.ogg', 50, 1)
				new /obj/effect/temp_visual/at_shield(T, T)
				break
			T.narsie_act(TRUE, TRUE)
			for(var/mob/living/target in T.contents)
				if(iscultist(target))
					new /obj/effect/temp_visual/cult/sparks(T)
					if(ishuman(target))
						var/mob/living/carbon/human/H = target
						if(H.stat != DEAD)
							H.reagents.add_reagent(/datum/reagent/fuel/unholywater, 7)
					if(isshade(target) || isconstruct(target))
						var/mob/living/simple_animal/M = target
						if(M.health+15 < M.maxHealth)
							M.adjustHealth(-15)
						else
							M.health = M.maxHealth
				else
					var/mob/living/L = target
					if(L.density)
						L.DefaultCombatKnockdown(20)
						L.adjustBruteLoss(45)
						playsound(L, 'sound/hallucinations/wail.ogg', 50, 1)
						L.emote("realagony")
		var/datum/beam/current_beam = new(user,temp_target,time=7,beam_icon_state="blood_beam",btype=/obj/effect/ebeam/blood)
		INVOKE_ASYNC(current_beam, TYPE_PROC_REF(/datum/beam, Start))


/obj/effect/ebeam/blood
	name = "blood beam"

/obj/item/shield/mirror
	name = "mirror shield"
	desc = "An infamous shield used by Nar'Sien sects to confuse and disorient their enemies. Its edges are weighted for use as a throwing weapon - capable of disabling multiple foes with preternatural accuracy."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "mirror_shield" // eshield1 for expanded
	lefthand_file = 'icons/mob/inhands/equipment/shields_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/shields_righthand.dmi'
	force = 5
	throwforce = 15
	throw_speed = 1
	throw_range = 4
	block_chance = 30 //bluemoon shange
	w_class = WEIGHT_CLASS_BULKY
	attack_verb = list("bumped", "prodded")
	hitsound = 'sound/weapons/smash.ogg'
	var/illusions = 2

/obj/item/shield/mirror/check_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	block_return[BLOCK_RETURN_REFLECT_PROJECTILE_CHANCE] = max(block_return[BLOCK_RETURN_REFLECT_PROJECTILE_CHANCE] || null, final_block_chance)
	return ..()

/obj/item/shield/mirror/run_block(mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
	if(iscultist(owner))
		if(istype(object, /obj/item/projectile) && (attack_type == ATTACK_TYPE_PROJECTILE))
			if(is_energy_reflectable_projectile(object))
				final_block_chance += 70 //bluemoon shange
				if(prob(final_block_chance))
					block_return[BLOCK_RETURN_REDIRECT_METHOD] = REDIRECT_METHOD_RETURN_TO_SENDER //bluemoon shange
					return BLOCK_SUCCESS | BLOCK_SHOULD_REDIRECT | BLOCK_PHYSICAL_EXTERNAL | BLOCK_REDIRECTED
				return BLOCK_NONE	//To avoid reflection chance double-dipping with block chance
			var/obj/item/projectile/P = object
			if(P.damage >= 30)
				var/turf/T = get_turf(owner)
				T.visible_message("<span class='warning'>The sheer force from [P] shatters the mirror shield!</span>")
				new /obj/effect/temp_visual/cult/sparks(T)
				playsound(T, 'sound/effects/glassbr3.ogg', 100)
				owner.Paralyze(25) //BULEMOON REBALANCE Смена обычного падения на паралич.
				qdel(src)
				return BLOCK_NONE
		. = ..()
		if(. & BLOCK_SUCCESS)
			playsound(src, 'sound/weapons/parry.ogg', 100, 1)
			if(illusions > 0)
				illusions--
				addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/shield/mirror, readd)), 450)
				if(prob(60))
					var/mob/living/simple_animal/hostile/illusion/M = new(owner.loc)
					M.faction = list("cult")
					M.Copy_Parent(owner, 70, 10, 5)
					M.move_to_delay = owner.movement_delay()
				else
					var/mob/living/simple_animal/hostile/illusion/escape/E = new(owner.loc)
					E.Copy_Parent(owner, 70, 10)
					E.GiveTarget(owner)
					E.Goto(owner, owner.movement_delay(), E.minimum_distance)
			return
	else
		if(prob(50))
			var/mob/living/simple_animal/hostile/illusion/H = new(owner.loc)
			H.Copy_Parent(owner, 100, 20, 5)
			H.faction = list("cult")
			H.GiveTarget(owner)
			H.move_to_delay = owner.movement_delay()
			to_chat(owner, "<span class='danger'><b>[src] betrays you!</b></span>")
		return BLOCK_NONE

/obj/item/shield/mirror/proc/readd()
	illusions++
	if(illusions == initial(illusions) && isliving(loc))
		var/mob/living/holder = loc
		to_chat(holder, "<span class='cult italic'>The shield's illusions are back at full strength!</span>")

/obj/item/shield/mirror/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/turf/T = get_turf(hit_atom)
	var/datum/thrownthing/D = throwingdatum
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		if(iscultist(L))
			playsound(src, 'sound/weapons/throwtap.ogg', 50)
			if(L.put_in_active_hand(src))
				L.visible_message("<span class='warning'>[L] catches [src] out of the air!</span>")
			else
				L.visible_message("<span class='warning'>[src] bounces off of [L], as if repelled by an unseen force!</span>")
		else if(!..())
			if(!L.anti_magic_check())
				if(is_servant_of_ratvar(L))
					L.DefaultCombatKnockdown(60)
				else
					L.DefaultCombatKnockdown(30)
				if(D.thrower)
					for(var/mob/living/Next in orange(2, T))
						if(!Next.density || iscultist(Next))
							continue
						throw_at(Next, 3, 1, D.thrower)
						return
					throw_at(D.thrower, 7, 1, null)
	else
		..()
