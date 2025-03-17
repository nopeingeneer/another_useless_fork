/datum/ert/firesquad // Пожиратели огня
	roles = list(/datum/antagonist/ert/firesquad)
	leader_role = /datum/antagonist/ert/firesquad/leader
	enforce_human = TRUE
	rename_team = "NT Flametroopers Squad"
	code = "Red"
	mission = "Экипаж станции не справляется с активной биологической угрозой. Окажите соответствующую поддержку."
	polldesc = "elite Nanotrasen Fire Team"
	ertphrase = "modular_bluemoon/sound/ert/ert_firesquad_send.ogg"

/datum/ert/heavysquad // Удар молота
	roles = list(/datum/antagonist/ert/heavysquad, /datum/antagonist/ert/heavysquad/machinegun)
	leader_role = /datum/antagonist/ert/heavysquad/leader
	rename_team = "NT Heavy Weapons Squad"
	code = "Delta"
	mission = "По имеющимся разведанным на станции присутствует особо опасный и тяжеловооруженный противник. Корпорация заинтересована в сохранении своих активов. Разберитесь с проблемой."
	polldesc = "elite Nanotrasen Heavy Team"
	ertphrase = "modular_bluemoon/sound/ert/ert_heavysquad_send.ogg"

/datum/ert/russian_ert // НРИ
	roles = list(/datum/antagonist/ert/russian_ert, /datum/antagonist/ert/russian_ert/support)
	leader_role = /datum/antagonist/ert/russian_ert/leader
	rename_team = "Novaya Rossiyskaya Imperiya Spetsnaz Squad"
	code = "Delta"
	mission = "От одной из близлежащих космических станций получен сигнал о помощи. Мы связались с НТ и получили добро на вмешательство. Окажите поддержку."
	polldesc = "Novaya Rossiyskaya Imperiya Spetsnaz Squad"
	ertphrase = "modular_bluemoon/sound/ert/nri_send.ogg"

/datum/ert/sol_ert // Солнечная Федерация
	roles = list(/datum/antagonist/ert/sol_ert, /datum/antagonist/ert/sol_ert/support)
	leader_role = /datum/antagonist/ert/sol_ert/leader
	rename_team = "Solar Federation Marine Squad"
	code = "Delta"
	mission = "НТ авторизовало интервенцию сил Солнечной Федерации на космическую станцию. Окажите помощь её экипажу."
	polldesc = "Solar Federation Marine Squad"
	ertphrase = "modular_bluemoon/sound/ert/sol_send.ogg"

/datum/ert/engineer_ert // Инженерное подразделение
	roles = list(/datum/antagonist/ert/engineer)
	leader_role = /datum/antagonist/ert/engineer_squadleader
	rename_team = "Emergency Engineer Squad"
	code = "Orange"
	mission = "Окажите поддержку станции по части ремонтных работ."
	polldesc = "Emergency Engineer Squad"
	//ertphrase = "modular_bluemoon/sound/ert/sol_send.ogg"

/datum/ert/ntr_ert // Агенты Внутренних Дел
	roles = list(/datum/antagonist/ert/ntr_ert_agent)
	leader_role = /datum/antagonist/ert/ntr_ert_leader
	rename_team = "Internal Affairs Squad"
	code = "Red"
	mission = "Слушайтесь Представителя Корпорации. Окажите поддержку Представителю Корпорации в установлении порядка и верховенства права на станции."
	polldesc = "Internal Affairs Squad"
	teamsize = 4
	//ertphrase = "modular_bluemoon/sound/ert/sol_send.ogg"

/datum/ert/maid_ert // рофлоЕРТ горничных
	roles = list(/datum/antagonist/ert/maid)
	leader_role = /datum/antagonist/ert/maid_leader
	rename_team = "Elite maid Squad"
	code = "Delta"
	mission = "Наведите порядок на станции, если вы понимаете, что офицер ССО имел ввиду."
	polldesc = "Elite maid Squad"
	teamsize = 5
	//ertphrase = "modular_bluemoon/sound/ert/sol_send.ogg"

/datum/ert/zealteam_ert // Удар наковальней
	roles = list(/datum/antagonist/ert/zeal_team)
	leader_role = /datum/antagonist/ert/zeal_team/leader
	rename_team = "Zeal Team Squad"
	polldesc = "Zeal Team Squad"
	code = "Delta"
	mission = "По имеющимся разведанным на станции присутствует особо опасный и тяжеловооруженный противник. Корпорация заинтересована в сохранении своих активов. Разберитесь с проблемой."
	ertphrase = "modular_bluemoon/sound/ert/ert_heavysquad_send.ogg"

/datum/ert/rabbit
	roles = list(/datum/antagonist/ert/security/rabbit)
	leader_role = /datum/antagonist/ert/commander/rabbit
	teamsize = 6
	opendoors = FALSE
	rename_team = "Rabbit Team"
	mission = "Устраните любые нарушения и/или отклонения от нормы на станции."
	polldesc = "a Rabbit Team"
	code = "Orange"
	ertphrase = 'modular_bluemoon/sound/ert/rabbit_protocol.ogg'

/datum/ert/lfwb_ordinator
	roles = list(/datum/antagonist/ert/lfwb_ordinator)
	leader_role = /datum/antagonist/ert/lfwb_ordinator/leader
	opendoors = TRUE
	rename_team = "Tribunal Ordinator"
	code = "Red"
	mission = "Уничтожить все угрозы Активам Пакта."
	polldesc = "an Nanotrasen Tribunal Ordinator"
	ertphrase = "modular_bluemoon/sound/ert/ert_tribunal.ogg"
