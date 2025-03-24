/obj/item/clothing/head/donator/bm
	icon = 'modular_bluemoon/fluffs/icons/obj/clothing/hats.dmi'
	mob_overlay_icon = 'modular_bluemoon/fluffs/icons/mob/clothing/hats.dmi'

/obj/item/clothing/head/donator/bm/pt_crown
	name = "Crown of Pure Tyranny"
	desc = "Корона, выполненная из оникса и обсидиана, украшенная прекрасным зелёным камнем и воплощающая самое потаённое зло и ненависть, заложенные в ней. Должно быть, кто-то действительно постарался ради её создания, как и носитель, сохранивший её. Она кажется до жути знакомой."
	icon_state = "pt_crown"
	item_state = "jackboots"

/obj/item/clothing/head/donator/bm/bishop_mitre
	name = "GPC Mitre"
	desc = "Один из символов Серой Постхристианской церкви. Внушает власть и уважение одним лишь своим видом."
	icon_state = "tall_mitre"
	item_state = "balaclava"

/obj/item/clothing/head/donator/bm/blueflame
	name = "horns of blue flame"
	desc = "It's horns of blue flame. A brightly glowing hologram that looks like fire, as if someone turned on the welding."
	icon_state = "blueflame"
	item_state = "jackboots"

/obj/item/clothing/head/donator/bm/cerberus_helmet
	name = "cerberus helmet"
	desc = "Шлем-маска напоминающая собачью голову с красными глазами. Она кажется вам знакомой и навевает страх. От неё пахнет тухлым мясом, от чего кружится голова. И как её вообще носят на голове..?"
	icon_state = "cerberushelm"
	item_state = "cerberushelm"
	flags_inv = HIDEFACIALHAIR|HIDEFACE|HIDEEYES|HIDEEARS|HIDEHAIR
	actions_types = list(/datum/action/item_action/cerberbark)

/datum/action/item_action/cerberbark
	name = "BARK!"

/obj/item/clothing/head/donator/bm/cerberus_helmet/verb/cerberbark()
	set category = "Object"
	set name = "BARK!"
	set src in usr
	if(!isliving(usr))
		return
	if(!can_use(usr))
		return

	var/frase
	frase = input("Какую фразу вы хотите сказать через преобразователь в шлеме?","") as text

	if(frase)
		usr.audible_message("[usr] barks, <font color='red' size='4'><b>[frase]</b></font>")
		playsound(src.loc, 'modular_bluemoon/fluffs/sound/bark.ogg', 100, 1)

/obj/item/clothing/head/donator/bm/cerberus_helmet/ui_action_click(mob/user, action)
	if(istype(action, /datum/action/item_action/cerberbark))
		cerberbark()

/obj/item/clothing/head/helmet/space/plasmaman/security/reaper
	name = "Security Plasma Envirosuit Helmet"
	desc = "Plasmaman Envirohelmet. Has red markings and reinforced with some composite materials."
	icon = 'modular_bluemoon/fluffs/icons/obj/clothing/hats.dmi'
	mob_overlay_icon = 'modular_bluemoon/fluffs/icons/mob/clothing/hats.dmi'
	icon_state = "pluto_enviro"

/obj/item/clothing/head/donator/bm/flektarn_beret
	name = "flektarn beret"
	desc = "Five-color, -explosive- beret in camouflage colors with a golden badge."
	icon_state = "flektarn_beret"
	item_state = "flektarn_beret"

/obj/item/clothing/head/donator/bm/nri_drg_head // civil version of nri antagonist beret
	name = "covet ops headgear"
	desc = "A special headger containing unknown fibers and electronics, providing the NVG effect for it's user. Formerly."
	icon_state = "nri_drg_ushanka"
	item_state = "nri_drg_ushanka"
	icon = 'modular_bluemoon/kovac_shitcode/icons/rus/obj_drg.dmi'
	mob_overlay_icon = 'modular_bluemoon/kovac_shitcode/icons/rus/mob_drg.dmi'
	unique_reskin = list(
		"Ushanka" = list("icon_state" = "nri_drg_ushanka"),
		"Beret" = list("icon_state" = "nri_drg_beret")
	)

/obj/item/modkit/tagilla
	name = "Tagilla Kit"
	desc = "A modkit for making a Welding helmet into a Tagilla welding helmet."
	product = /obj/item/clothing/head/welding/tagilla
	fromitem = list(/obj/item/clothing/head/welding)

/obj/item/clothing/head/welding/tagilla
	name = "Provocateur welding Helmet"
	desc = "На вид обычная сварочная маска разрисованная с лицевой стороны,особенно выделяется надпись «Убей» под визором."
	icon_state = "provocateur"
	item_state = "provocateur"
	icon = 'modular_bluemoon/fluffs/icons/obj/clothing/hats.dmi'
	mob_overlay_icon = 'modular_bluemoon/fluffs/icons/mob/clothing/hats.dmi'

/obj/item/clothing/head/HoS/dread_helmet
	name = "Шлем Судьи"
	desc = "Стандартный шлем судьи из Мега-Города Солнечной Федерации. Оснащен слоем кевлара и других материалов что защищают голову и визор что защищает от осколков и вспышек. Имеет встроенный микрофон с динамиком в который непонятно почему вам так и хочется сказать Я! ЗАКОН!"
	icon_state = "dread_helmet"
	item_state = "dread_helmet"
	icon = 'modular_bluemoon/fluffs/icons/obj/clothing/hats.dmi'
	mob_overlay_icon = 'modular_bluemoon/fluffs/icons/mob/clothing/hats.dmi'
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEHAIR|HIDEEARS|HIDESNOUT

/obj/item/clothing/head/donator/bm/royal_hunters
	name = "Royal hunters hat"
	desc = "Even Hunters die, but not memories"
	icon_state = "royal_hunters"
	item_state = "royal_hunters"
	mob_overlay_icon = 'modular_bluemoon/fluffs/icons/mob/large-worn-icons/32x48/head.dmi'

/obj/item/clothing/head/donator/bm/ushankich
	name = "ushanka"
	desc = "Perfect for winter in Siberia, da?"
	icon_state = "sovietushankadown"
	item_state = "sovietushankadown"
	flags_inv = HIDEEARS
	var/earflaps = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = COAT_MAX_TEMP_PROTECT
	///Sprite visible when the ushanka flaps are folded up.
	var/upsprite = "sovietushankaup"
	///Sprite visible when the ushanka flaps are folded down.
	var/downsprite = "sovietushankadown"

/obj/item/clothing/head/donator/bm/ushankich/attack_self(mob/user)
	if(earflaps)
		icon_state = upsprite
		item_state = upsprite
		to_chat(user, "<span class='notice'>You raise the ear flaps on the ushanka.</span>")
	else
		icon_state = downsprite
		item_state = downsprite
		to_chat(user, "<span class='notice'>You lower the ear flaps on the ushanka.</span>")
	earflaps = !earflaps

/obj/item/clothing/head/helmet/chaplain/wh_helmet
	name = "The Helmet of the Dark Apostle"
	desc = "This is the helmet of one of the dark apostles serving the Dark Gods. The face mask is made in the shape of a screaming demon"
	icon = 'modular_bluemoon/fluffs/icons/obj/clothing/hats.dmi'
	mob_overlay_icon = 'modular_bluemoon/fluffs/icons/mob/clothing/hats.dmi'
	icon_state = "wh_chaplain"

/obj/item/modkit/whhelmet_kit
	name = "The Helmet of the Dark Apostle modkit"
	desc = "A modkit for making an chaplain helmet into The Helmet of the Dark Apostle"
	product = /obj/item/clothing/head/helmet/chaplain/wh_helmet
	fromitem = list(/obj/item/clothing/head/helmet/chaplain, /obj/item/clothing/head/helmet/chaplain/bland/horned, /obj/item/clothing/head/helmet/chaplain/bland/winged, /obj/item/clothing/head/helmet/chaplain/bland)

//////////////////////////////////////////////////

/obj/item/clothing/head/hardhat/weldhat/mengineer
	name = "master engineer's hardhat"
	desc = "A modified piece of welding hardhat with ear cover. White-yellow coloring seems to indicate some engineering mid-rank, not used by Nanotrasen standarts. You can see personal number engraved inside the hat: KVM:829917."
	icon = 'modular_bluemoon/fluffs/icons/obj/clothing/hats.dmi'
	mob_overlay_icon = 'modular_bluemoon/fluffs/icons/mob/clothing/hats.dmi'
	icon_state = "hardhat0_mengineer"
	item_state = "hardhat0_mengineer"
	hat_type = "mengineer"
	actions_types = list(/datum/action/item_action/toggle_helmet_light, /datum/action/item_action/toggle_welding_screen)
	flags_inv = HIDEEYES | HIDEFACE | HIDEEARS

/obj/item/clothing/head/hardhat/weldhat/mengineer/worn_overlays(isinhands, icon_file, used_state, style_flags = NONE)
	. = list()
	SEND_SIGNAL(src, COMSIG_ITEM_WORN_OVERLAYS, isinhands, icon_file, used_state, style_flags, .)
	if(!isinhands)
		if(damaged_clothes)
			. += mutable_appearance('icons/effects/item_damage.dmi', "damagedhelmet")
		if(blood_DNA)
			. += mutable_appearance('icons/effects/blood.dmi', "helmetblood", color = blood_DNA_to_color(), blend_mode = blood_DNA_to_blend())
		if(!up)
			. += mutable_appearance('icons/mob/clothing/head.dmi', "weldvisor")

/////////////////////////////////////////////////////
