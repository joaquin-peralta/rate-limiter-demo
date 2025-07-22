import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  connect() {
    this.timeout = setTimeout(() => {
      this.element.remove()
    }, 5000) // 5000ms = 5 seconds
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
