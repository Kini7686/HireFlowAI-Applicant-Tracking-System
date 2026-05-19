import { Controller } from "@hotwired/stimulus"

// Polls for ATS score after recalculate when Action Cable update is missed
export default class extends Controller {
  static values = { url: String, interval: { type: Number, default: 2000 } }

  connect() {
    this.startPolling()
  }

  disconnect() {
    this.stopPolling()
  }

  startPolling() {
    this.stopPolling()
    this.timer = setInterval(() => this.checkScore(), this.intervalValue)
    this.checkScore()
  }

  stopPolling() {
    if (this.timer) clearInterval(this.timer)
  }

  async checkScore() {
    const response = await fetch(this.urlValue, {
      credentials: "same-origin",
      headers: {
        Accept: "application/json",
        "X-Requested-With": "XMLHttpRequest"
      }
    })
    if (!response.ok) return

    const data = await response.json()
    if (data.ats_score != null) {
      this.stopPolling()
      if (data.row_html) {
        this.element.outerHTML = data.row_html
      }
    }
  }
}
