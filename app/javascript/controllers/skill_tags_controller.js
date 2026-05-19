import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.inputTarget.addEventListener("keydown", this.tagify.bind(this))
  }

  tagify(event) {
    if (event.key === "Enter") {
      event.preventDefault()
      const value = this.inputTarget.value.trim()
      if (value && !value.endsWith(",")) {
        this.inputTarget.value = value + ", "
      }
    }
  }
}
