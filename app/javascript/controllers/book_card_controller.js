import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="book-card"
export default class extends Controller {
  connect() {
    alert("arroz")
    this.element.textContent = "Hello World!"
  }
}
