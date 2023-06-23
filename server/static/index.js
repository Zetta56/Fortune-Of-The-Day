const fortuneDiv = document.querySelector("#message");
const suggestionForm = document.querySelector("#suggestion-form");
const rerollButton = document.querySelector("#reroll");

const pickMessage = async () => {
  const data = await fetch("/api/pick").then(res => res.text());
  fortuneDiv.textContent = data;
};

const postMessage = (message) => {
  fetch("/api/upload", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ message: message })
  });
};

document.addEventListener("DOMContentLoaded", () => {
  pickMessage();
});

rerollButton.addEventListener("click", () => {
  pickMessage();
});

suggestionForm.addEventListener("submit", (e) => {
  e.preventDefault();
  postMessage(e.target["message-field"].value);
  e.target["message-field"].value = "";
});
