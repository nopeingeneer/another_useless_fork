
/obj/machinery/jukebox/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if ("random_song")
			ui_act("add_to_queue", list("track" = pick(SSjukeboxes.songs)), ui, state)
			return TRUE
		if ("remove_from_queue")
			var/index = params["index"]
			if (!index || !queuedplaylist.len || index < 1 || index > queuedplaylist.len)
				return
			var/datum/track/song_to_remove = queuedplaylist[index]
			queuedplaylist.Cut(index, index + 1)
			say("[song_to_remove.song_name] была удалена из очереди.")
			return TRUE


/obj/item/jukebox/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if ("random_song")
			ui_act("add_to_queue", list("track" = pick(SSjukeboxes.songs)), ui, state)
			return TRUE
		if ("remove_from_queue")
			var/index = params["index"]
			if (!index || !queuedplaylist.len || index < 1 || index > queuedplaylist.len)
				return
			var/datum/track/song_to_remove = queuedplaylist[index]
			queuedplaylist.Cut(index, index + 1)
			say("[song_to_remove.song_name] была удалена из очереди.")
			return TRUE

/obj/item/sign/moniq/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if ("random_song")
			ui_act("add_to_queue", list("track" = pick(SSjukeboxes.songs)), ui, state)
			return TRUE
		if ("remove_from_queue")
			var/index = params["index"]
			if (!index || !queuedplaylist.len || index < 1 || index > queuedplaylist.len)
				return
			var/datum/track/song_to_remove = queuedplaylist[index]
			queuedplaylist.Cut(index, index + 1)
			say("[song_to_remove.song_name] была удалена из очереди.")
			return TRUE

/obj/structure/sign/moniq/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if ("random_song")
			ui_act("add_to_queue", list("track" = pick(SSjukeboxes.songs)), ui, state)
			return TRUE
		if ("remove_from_queue")
			var/index = params["index"]
			if (!index || !queuedplaylist.len || index < 1 || index > queuedplaylist.len)
				return
			var/datum/track/song_to_remove = queuedplaylist[index]
			queuedplaylist.Cut(index, index + 1)
			say("[song_to_remove.song_name] была удалена из очереди.")
			return TRUE
