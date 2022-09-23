import consumer from "./consumer"

consumer.subscriptions.create({ channel: "ProjectChannel" }, {
  received(data) {
    const element = document.getElementById("project_" + data.project_id);
    const numberOfRevisionsToShow = element.dataset.numberOfRevisionsToShow;

    element.innerHTML = data.html
    const revisions = element.querySelectorAll(".revision")
    Array.from(revisions).slice(numberOfRevisionsToShow).forEach(function(i, e) {
      e.classList.add("hide")
    })
  }
})
