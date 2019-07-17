//= require spree/frontend
//= require spree/frontend/spree_auth

// Initialize
function Review(inputs) {
  for (var key in inputs){
    this[key] = inputs[key];
  }
}

function elementExist(element){
  return (typeof element != 'undefined' && element != null)
}

Review.prototype.onLoad = function () {
  if (elementExist(this.reviewForm)) this.formHandler()
  if (elementExist(this.editStars)) this.starRating()
}

Review.prototype.formHandler = function () {
  var formEvent = ['ajax:success', 'ajax:error'];
  for(var i = 0; i < formEvent.length; i++) {
    this.reviewForm.addEventListener(formEvent[i], function(event) {
      var detail = event.detail;
      var data = detail[0], status = detail[1], xhr = detail[2];

      if (xhr.status == 401){
        response = xhr.responseText;
        document.getElementById('error-message').innerHTML = response
      }
      else {
        reviewContainer = document.getElementsByClassName('post-review')
        reviewContainer[0].classList.add('d-block')
      }
    })
  }
}

Review.prototype.starRating = function () {
  var stars = this.editStars;
  for (var i = 0; i < stars.length; i++){
    stars[i].addEventListener('click', function(event) {
      var element = event.target;
      var selected_stars = parseInt(element.children[0].value.split(' ')[0])
      for (var i = 0; i < stars.length; i++){
        if (i < selected_stars) {
          if (!stars[i].classList.contains('fas')) stars[i].classList.add('fas')
        }
        else stars[i].classList.remove('fas')
        stars[i].children[0].removeAttribute('checked')
      }
      element.children[0].setAttribute('checked', '')
    }, false)
  }
}

document.addEventListener("turbolinks:load", function() {
  var reviewInit = function(){
    var inputs = {
      editStars: document.getElementsByClassName('s-edit'),
      reviewForm: document.getElementById('new_review')
    };
    return new Review(inputs).onLoad()
  }

  reviewInit(); // Calling Function
});
