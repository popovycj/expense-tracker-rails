import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        mutation.addedNodes.forEach((node) => {
          if (node.nodeType === Node.ELEMENT_NODE) {
            this.processNewElement(node)
          }
        })
      })
    })

    observer.observe(this.element, { childList: true })
  }

  processNewElement(node) {
    node.classList.add("bg-success", "p-2", "text-dark", "bg-opacity-25")
  }
}
