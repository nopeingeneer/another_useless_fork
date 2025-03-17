/datum/reagent/consumable/semen/reaction_mob(mob/living/M, method, reac_volume) //splashing or ingesting
	. = ..()
	if(!.)
		return
	if(!istype(src, /datum/reagent/consumable/semen/femcum))
		if(HAS_TRAIT(M, TRAIT_GFLUID_DETECT))
			to_chat(M, span_love("Вы узнаете хорошо знакомый вам вкус свежей спермы~"))
		if(HAS_TRAIT(M, TRAIT_DUMB_CUM))
			//var/datum/quirk/dumb4cum/quirk_target = locate() in M.roundstart_quirks
			//quirk_target.uncrave()
			//M.set_drugginess(1)
			if(prob(15))
				to_chat(M, span_love(pick("Как же вкусно!~", "Восхитительно!~", "Невозможно удержаться!~")))
				M.emote("moan")

/datum/reagent/consumable/semen/on_merge(data, amount, mob/living/carbon/M, purity) //when we add more through ERP panel
	. = ..()
	if(!iscarbon(M))
		return
	if(HAS_TRAIT(M,TRAIT_DUMB_CUM) && !istype(src, /datum/reagent/consumable/semen/femcum))
		var/datum/quirk/dumb4cum/quirk_target = locate() in M.roundstart_quirks
		quirk_target.uncrave()

/datum/reagent/consumable/semen/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(iscatperson(M) && HAS_TRAIT(M,TRAIT_DUMB_CUM)  && !istype(src, /datum/reagent/consumable/semen/femcum)) //special "milk" tastes nice for special felinids
		if(prob(3))
			to_chat(M, span_notice(pick("Mmmm~ boy's milk feels so good inside me~", "Ahh~ boy's milk~")))
			M.emote("purr")

/datum/reagent/consumable/ethanol/cum_in_a_hot_tub/semen/reaction_mob(mob/living/carbon/M)
	. = ..()
	if(!.)
		return
	if(HAS_TRAIT(M, TRAIT_GFLUID_DETECT) || HAS_TRAIT(M,TRAIT_DUMB_CUM))
		to_chat(M, span_love("Вы чувствуете явную нотку свежей спермы в напитке~"))

/datum/reagent/blood/oil
	data = list("donor"=null,"viruses"=null,"blood_DNA"="REPLICATED", "bloodcolor" = BLOOD_COLOR_OIL, "bloodblend" = BLEND_MULTIPLY, "blood_type"="HF","resistances"=null,"trace_chem"=null,"mind"=null,"ckey"=null,"gender"=null,"real_name"=null,"cloneable"=null,"factions"=null)
	name = "Hydraulic Liquid"
	description = "Hydraulic liquid for synthetic crewmembers."
	taste_description = "oil"
	color = BLOOD_COLOR_OIL
	value = REAGENT_VALUE_NONE

/datum/reagent/blood/fancy
	name = "High Quality Blood"
	description = "A noble virgin donor's blood."
	taste_description = "sweet innocence"
	glass_name = "glass of Vampire Delight"
	glass_desc = "To sate the fanged gentlemen and gentlewomen."

/datum/reagent/consumable/organicprecursor
	name = "Organic Precursor"
	description = "A very simple precursor-alike chemical that can be used in the creation of any specific liquids."
	color = "#FFFFFF" // rgb: 255, 255, 255
	taste_mult = 0 // oderless and tasteless
