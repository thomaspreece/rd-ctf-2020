import "./main";
import CTFd from "core/CTFd";
import $ from "jquery";
import { htmlEntities } from "core/utils";
import { ezQuery } from "core/ezq";

function deleteCorrectSubmission(event) {
  const key_id = $(this).data("submission-id");
  const $elem = $(this)
    .parent()
    .parent();
  const chal_name = $elem
    .find(".chal")
    .text()
    .trim();
  const team_name = $elem
    .find(".team")
    .text()
    .trim();

  const row = $(this)
    .parent()
    .parent();

  ezQuery({
    title: "Delete Submission",
    body: "Are you sure you want to delete correct submission from {0} for challenge {1}".format(
      "<strong>" + htmlEntities(team_name) + "</strong>",
      "<strong>" + htmlEntities(chal_name) + "</strong>"
    ),
    success: function() {
      CTFd.api
        .delete_submission({ submissionId: key_id })
        .then(function(response) {
          if (response.success) {
            row.remove();
          }
        });
    }
  });
}

function deleteSelectedSubmissions(event) {
  let submissionIDs = $("input[data-submission-id]:checked").map(function() {
    return $(this).data("submission-id");
  });
  let target = submissionIDs.length === 1 ? "submission" : "submissions";

  ezQuery({
    title: "Delete Submissions",
    body: `Are you sure you want to delete ${submissionIDs.length} ${target}?`,
    success: function() {
      const reqs = [];
      for (var subId of submissionIDs) {
        reqs.push(CTFd.api.delete_submission({ submissionId: subId }));
      }
      Promise.all(reqs).then(responses => {
        window.location.reload();
      });
    }
  });
}

function toggleSubmissionSelect(event) {
  const checked = $(this).prop("checked");
  $(this)
    .closest("table")
    .find("input[data-submission-id]")
    .prop("checked", checked);
}

$(() => {
  $(".delete-correct-submission").click(deleteCorrectSubmission);
  $("#submissions-bulk-select").change(toggleSubmissionSelect);
  $("#submission-delete-button").click(deleteSelectedSubmissions);
});
