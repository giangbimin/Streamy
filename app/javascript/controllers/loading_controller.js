import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['loading'];

  displayLoading() {
    console.log("displayLoading");
    this.loadingTarget.classList.remove("hidden");
    this.loadingTarget.classList.add("absolute");
  }

  hideLoading() {
    this.loadingTarget.classList.add("hidden");
    this.loadingTarget.classList.remove("absolute");
  }
}
