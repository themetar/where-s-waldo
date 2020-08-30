// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

document.addEventListener("turbolinks:load", () => {
  let btn = document.getElementsByTagName("button")[0];
  btn && btn.addEventListener("click", event => {
    document.getElementsByClassName("scenes-list")[0].classList.remove("hidden");
  });
});
