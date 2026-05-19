import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  preview() {
    const file = this.inputTarget.files[0]
    if (file) {
      this.previewTarget.textContent = `Selected: ${file.name} (${Math.round(file.size / 1024)} KB)`
    }
  }
}
