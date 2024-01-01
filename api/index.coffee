import { log } from "./src/logger.coffee"
import * as scrapper from "./src/scrapper.coffee"
import * as tmdb from "./src/tmdb.coffee"
import * as custom from "./src/custom.coffee"
import express from "express"

ADDRESS = "127.0.0.1"
PORT = 3000

api = express()
api.use express.json()

# @route GET /api/schedule
# @returns {Object} with schedule information
api.get "/api/schedule", (req, res) ->
  log "request", "Request to fetch schedule from #{req.ip}."
  res.send await scrapper.getSchedule()

# @route POST /api/show/episodes
# @param showURL - string (must be from Subsplease)
# @returns {Object} with episodes magnet links
api.post "/api/show/episodes", (req, res) ->
  data = req.body

  log "request", "Request to fetch episodes from #{req.ip}."
  res.send await scrapper.getShowEpisodes data.showURL

# @route POST /api/show/year
# @param showURL - string (must be from Subsplease)
# @returns {Object} with name and release year
api.post "/api/show/profile", (req, res) ->
  data = req.body

  log "request", "Request to fetch show name and release year from #{req.ip}."
  res.send await scrapper.getShowProfile data.showURL

# @route POST /api/show/id
# @param showName - string
#        showYear - string
# @returns showID - int32
api.post "/api/show/id", (req, res) ->
  data = req.body

  log "request", "Request to fetch show TMDB ID from #{req.ip}."
  res.send await tmdb.getShowID data.showName, data.showYear

# @route POST /api/show/details
# @param showID - int32
# @returns {Object} with show details
api.post "/api/show/details", (req, res) ->
  data = req.body

  log "request", "Request to fetch show details from #{req.ip}."
  res.send await tmdb.getShowDetails data.showID

# @route POST /api/show/episode_details
# @param showID - int32
#        seasonNumber - int32
#        episodeNumber - int32
# @returns {Object} with episode details
api.post "/api/show/episode/details", (req, res) ->
  data = req.body

  log "request", "Request to fetch episode details from #{req.ip}."
  res.send(
    await tmdb.getEpisodeDetails(
      data.showID
      data.seasonNumber
      data.episodeNumber
    )
  )

# @route POST /api/show/episode_details
# @param shows - Object
# @returns {Object} with carousel data
api.post "/api/carousel", (req, res) ->
  data = req.body

  log "request", "Request to fetch carousel data from #{req.ip}"
  res.send await custom.getCarouselData data.shows

api.listen PORT, ADDRESS, ->
  log "access", "Listening on http://#{ADDRESS}:#{PORT}/api"
