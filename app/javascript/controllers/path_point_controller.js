import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["body", "gravity"]
  static values = { gravities: Object }

  connect() {
    this.updateGravity()
  }

  updateGravity() {
    if (!this.hasBodyTarget || !this.hasGravityTarget) return

    const gravity = this.gravitiesValue[this.bodyTarget.value]
    if (gravity == null) return

    this.gravityTarget.textContent = Number(gravity).toFixed(3)
  }

  remove() {
    this.element.remove()
  }
}
