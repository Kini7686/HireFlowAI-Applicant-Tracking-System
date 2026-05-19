import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["column"]

  dragStart(event) {
    event.dataTransfer.setData("application/id", event.target.dataset.id)
    event.dataTransfer.effectAllowed = "move"
  }

  dragEnd(event) {
    const id = event.dataTransfer.getData("application/id")
    const column = event.target.closest("[data-pipeline-target='column']") ||
      this.columnTargets.find(col => col.contains(event.relatedTarget))

    if (!column || !id) return

    const status = column.dataset.status
    const token = document.querySelector("meta[name='csrf-token']")?.content

    fetch(`/applications/${id}/update_status`, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": token,
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: `status=${status}`
    })
  }
}
