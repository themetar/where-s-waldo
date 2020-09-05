// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

const makeTargetBox = function (characters, changeHandler) {
  const div = document.createElement("div");
  div.classList.add("target-box");
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

const makeHitMarkerBox = function (characterName) {
  const div = document.createElement("div");
  div.classList.add("hit-marker");
  const whiteFill = div.appendChild(document.createElement("div"));
  whiteFill.classList.add("white-fill");
  const innerFrame = whiteFill.appendChild(document.createElement("div"));
  innerFrame.classList.add("inner-frame");
  const nameTag = div.appendChild(document.createElement("div"));
  nameTag.classList.add("name-tag");
  nameTag.appendChild(document.createTextNode(characterName));
  return div;
};

const makeMissMarker = function() {
  const div = document.createElement("div");
  div.classList.add("miss-marker");
  div.addEventListener("animationend", () => div.parentElement.removeChild(div));
  return div;
};

document.addEventListener("turbolinks:load", () => {
  const token = document.getElementsByName('csrf-token')[0].content;

  let sceneBox = document.getElementById("scene-container");

  const addToSceneBox = function(element, {x, y}) {
    element.style.left = x + "px";
    element.style.top = y + "px";
    sceneBox.appendChild(element);
  };

  let targetBoxAdded = false;
  let targetBox;

  let charactersToFind = {
    "waldo": "Waldo",
    "wenda": "Wenda",
    "wizard": "Whitebeard",
    "odlaw": "Odlaw",
  };

  let cursor;
  let characterGuess;

  let waitingOnAPI = false;
  let waitingMarker = makeWaitingMarker();

  const onCharacterSelect = function(event) {
    characterGuess = event.target.value;

    const guess = new URLSearchParams({
      x: cursor.x,
      y: cursor.y,
      character: characterGuess,
    });

    // remove target box
    targetBox.parentElement.removeChild(targetBox);
    targetBoxAdded = false;
    targetBox = null;

    // set waiting flag
    waitingOnAPI = true;
    // add loading marker
    addToSceneBox(waitingMarker, cursor);

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
        // add hit marker
        const hitMarker = makeHitMarkerBox(charactersToFind[characterGuess]);
        addToSceneBox(hitMarker, cursor);

        // filter characters
        const remaining = data.remaining || [];
        charactersToFind = remaining.reduce((obj, value) => {obj[value] = charactersToFind[value]; return obj;}, {});
      } else {
        // add miss marker
        const missMarker = makeMissMarker();
        addToSceneBox(missMarker, cursor);
      }

      if (data.won) {
        let form_overlay = document.querySelector(".fullscreen-overlay");
        form_overlay.classList.remove("hidden");
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
    addToSceneBox(targetBox, cursor);
    targetBoxAdded = true;
  });
});
