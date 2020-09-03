// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

const makeTargetBox = function (characters, changeHandler) {
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
    Object.keys(characters).map(value => `<option value="${value}">${characters[value]}</option>`))
  ).join("");
  select.addEventListener("change", changeHandler);
  return div;
};

const resetTargetBoxSelection = function(box) {
  box.querySelector("select").value = "";
};

const makeWaitingMarker = function() {
  const div = document.createElement("div");
  div.classList.add("waiting-marker");
  return div;
};

document.addEventListener("turbolinks:load", () => {
  const token = document.getElementsByName('csrf-token')[0].content;

  let sceneBox = document.getElementById("scene-container");

  let targetBoxAdded = false;
  let targetBox;

  let charactersToFind = {
    "waldo": "Waldo",
    "wenda": "Wenda",
    "wizard": "Whitebeard",
    "odlaw": "Odlaw",
  };

  let cursor;

  let waitingOnAPI = false;
  let waitingMarker = makeWaitingMarker();

  const onCharacterSelect = function(event) {
    const guess = new URLSearchParams({
      x: cursor.x,
      y: cursor.y,
      character: event.target.value,
    });

    // remove target box
    targetBox.parentElement.removeChild(targetBox);
    targetBoxAdded = false;
    targetBox = null;

    // set waiting flag
    waitingOnAPI = true;
    // add loading marker
    waitingMarker.style.left = cursor.x + "px";
    waitingMarker.style.top = cursor.y + "px";
    sceneBox.appendChild(waitingMarker);

    fetch(window.location + "/guess",
      {
        method: "post",
        credentials: "same-origin",
        headers: {"X-CSRF-Token": token},
        body: guess,
      })
    .then(response => response.ok && response.json())
    .then(data => {
      // clear flag
      waitingOnAPI = false;
      // remove waiting marker
      sceneBox.removeChild(waitingMarker);

      if (data.result == "hit") {
        // TODO: add hit marker

        // filter characters
        const remaining = data.remaining || [];
        charactersToFind = remaining.reduce((obj, value) => {obj[value] = charactersToFind[value]; return obj;}, {});
      }

      if (data.won) {
        // TODO: show leaderboard form
        alert("Congrats! You found all characters!");
      }
    });
  };


  sceneBox.addEventListener("click", event => {
    if (waitingOnAPI) return;

    if (event.target.closest(".target-box")) return;

    if (targetBoxAdded) {
      targetBox.parentElement.removeChild(targetBox);
      targetBoxAdded = false;
      return;
    }

    cursor = {x: event.offsetX, y: event.offsetY};

    targetBox = targetBox || makeTargetBox(charactersToFind, onCharacterSelect);
    resetTargetBoxSelection(targetBox);
    targetBox.style.left = event.offsetX + "px";
    targetBox.style.top = event.offsetY + "px";
    sceneBox.appendChild(targetBox);
    targetBoxAdded = true;
  });
});
