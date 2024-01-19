import { useState, useEffect } from "react"
import axios from "axios"
import { BrowserRouter, Routes, Route } from "react-router-dom"
# Pages
import { Home } from "./pages/home.coffee"
import { Watch } from "./pages/watch.coffee"
import { Error } from "./pages/error.coffee"
# Components
import { Navbar } from "./components/navbar.coffee"
import { Footer } from "./components/footer.coffee"

export App = ->
  [scheduleData, setScheduleData] = useState null
  [isScheduleLoading, setIsScheduleLoading] = useState true

  # Fetch schedule
  useEffect(
    ->
      fetchSchedule = ->
        axios
          .get "/api/schedule"
          .then (response) ->
            setScheduleData response.data
            setIsScheduleLoading false
          .catch (error) ->
            return error

      fetchSchedule()
      return
  ,
    []
  )

  <>
    <BrowserRouter>
      <div className="flex flex-col min-h-screen">
        <Navbar
          scheduleData={scheduleData}
          isScheduleLoading={isScheduleLoading}
        />

        <Routes>
          <Route
            path="/"
            element={
              <Home
                scheduleData={scheduleData}
                isScheduleLoading={isScheduleLoading}
              />
            }
          />
          <Route path="/watch" element={<Watch />} />
          <Route path="*" element={<Error />} />
        </Routes>

        <Footer />
      </div>
    </BrowserRouter>
  </>
