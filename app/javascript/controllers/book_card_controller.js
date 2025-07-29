import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = [ "rating", "ratingDisplay" ]

  connect() {
    alert('ok')
    console.log("Book card controller connected!");
    this.updateRatingDisplay()
  }

  updateRatingDisplay() {
    if (this.hasRatingTarget && this.hasRatingDisplayTarget) {
      const rawValue = this.ratingTarget.textContent;
      const ratingValue = Math.round(parseFloat(rawValue));
      this.ratingDisplayTarget.innerHTML = this.getStarsRating(ratingValue);
    }
  }
  
  getStarsRating(rating) {
    let starsHTML = '<div class="stars-container">';
    
    for (let i = 1; i <= 5; i++) {
      if (i <= rating) {
        starsHTML += '<i class="fa-solid fa-star star filled"></i>';
      } else {
        starsHTML += '<i class="fa-regular fa-star star empty"></i>';
      }
    }
    
    starsHTML += `<span class="rating-text">(${rating}/5)</span></div>`;
    return starsHTML;
  }  
}