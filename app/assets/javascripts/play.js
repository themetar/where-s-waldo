// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

const charactersToFind = ["waldo", "wenda", "wizard", "odlaw"];

const makeTargetBox = function () {
  const div = document.createElement("div");
  div.classList.add("target-box");
  const whiteFill = div.appendChild(document.createElement("div"));
  whiteFill.classList.add("white-fill");
  const innerFrame = whiteFill.appendChild(document.createElement("div"));
  innerFrame.classList.add("inner-frame");
  const nameTag = div.appendChild(document.createElement("div"));
  nameTag.classList.add("name-tag");
  const select = nameTag.appendChild(document.createElement("select"));
  select.innerHTML = (["<option value=\"\">Who ?</option>"].concat(
    charactersToFind.map(char => `<option value="${char}">${char.replace(/^./, c => c.toUpperCase())}</option>`))
  ).join("");
  return div;
};

const resetTargetBoxSelection = function(box) {
  box.querySelector("select").value = "";
};


document.addEventListener("turbolinks:load", () => {
  let sceneBox = document.getElementById("scene-container");

  let targetBoxAdded = false;

  let targetBox = makeTargetBox();

  sceneBox.addEventListener("click", event => {
    if (event.target.closest(".target-box")) return;

    if (targetBoxAdded) {
      targetBox.parentElement.removeChild(targetBox);
      targetBoxAdded = false;
      return;
    }

    resetTargetBoxSelection(targetBox);
    targetBox.style.left = (event.offsetX - 50) + "px";
    targetBox.style.top = (event.offsetY - 50) + "px";
    sceneBox.appendChild(targetBox);
    targetBoxAdded = true;
  });
});
