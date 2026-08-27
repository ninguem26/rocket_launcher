import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["empty", "point"]

  connect() {
    this.refresh()
  }

  pointTargetConnected() {
    this.refresh()
  }

  pointTargetDisconnected() {
    this.refresh()
  }

  refresh() {
    if (this.hasEmptyTarget) {
      this.emptyTarget.hidden = this.pointTargets.length > 0
    }

    this.pointTargets.forEach((point, index) => {
      const label = point.querySelector("[data-step-index]")
      if (label) {
        label.textContent = String(index + 1)
      }
    })
  }
}
