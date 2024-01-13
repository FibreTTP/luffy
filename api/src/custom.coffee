import * as scrapper from "./scrapper.coffee"
import * as tmdb from "./tmdb.coffee"
import { log } from "./logger.coffee"

# Remove " SX" from name string
removeSeason = (name) ->
  name.replace(/ S\d+$/, "")

extractSeasonNumber = (name) ->
  regex = /S(\d+)$/

  if regex.test name
    match = regex.exec name

    return (if match? then parseInt match[1] else 1)
  else
    return 1

export getCarouselData = (shows) ->
  try
    data = []

    for show in shows
      showID = await tmdb.getShowID removeSeason show.name
      details = await tmdb.getShowDetails showID.id

      data.push details

    log "answer", "Fetched carousel data."
    return data
  catch
    log "error", "Error trying to fetch carousel data."
    return null

export getWatchData = (showURL) ->
  try
    showProfile = await scrapper.getShowProfile showURL
    showID =
      await tmdb.getShowID removeSeason(showProfile.name), showProfile.year
    details = await tmdb.getShowDetails showID.id

    # Specify season number
    details["season"] = extractSeasonNumber showProfile.name

    log "answer", "Fetched watch data."
    return details
  catch
    log "error", "Error trying to fetch watch data."
    return null
