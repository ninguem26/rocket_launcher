import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["empty", "point", "addLaunch", "addLanding"]

  connect() {
    this.refresh()
  }

  pointTargetConnected() {
    this.refresh()
  }

  pointTargetDisconnected() {
    this.refresh()
  }

  enableSelects() {
    this.pointTargets.forEach((point) => {
      const select = this.bodySelect(point)
      if (select) select.disabled = false
    })
  }

  refresh() {
    if (this.hasEmptyTarget) {
      this.emptyTarget.hidden = this.pointTargets.length > 0
    }

    this.pointTargets.forEach((point, index) => {
      const label = point.querySelector("[data-step-index]")
      if (label) label.textContent = String(index + 1)
    })

    this.applySequenceRules()
    this.updateAddButtons()
  }

  applySequenceRules() {
    this.pointTargets.forEach((point, index) => {
      const select = this.bodySelect(point)
      if (!select) return

      if (index === 0) {
        select.disabled = false
        return
      }

      const previous = this.pointTargets[index - 1]
      const previousManeuver = previous.dataset.maneuver
      const currentManeuver = point.dataset.maneuver

      if (previousManeuver === "land" && currentManeuver === "launch") {
        const previousBody = this.bodySelect(previous)?.value
        if (previousBody && select.value !== previousBody) {
          select.value = previousBody
          this.updateGravity(point)
        }
        select.disabled = true
      } else {
        select.disabled = false
      }
    })
  }

  updateAddButtons() {
    const lastManeuver = this.pointTargets.at(-1)?.dataset.maneuver

    if (this.hasAddLaunchTarget) {
      this.addLaunchTarget.hidden = lastManeuver === "launch"
    }

    if (this.hasAddLandingTarget) {
      this.addLandingTarget.hidden = lastManeuver === "land"
    }
  }

  bodySelect(point) {
    return point.querySelector("select")
  }

  updateGravity(point) {
    const controller = this.application.getControllerForElementAndIdentifier(point, "path-point")
    controller?.updateGravity()
  }
}
