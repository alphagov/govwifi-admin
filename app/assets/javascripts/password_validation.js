$("#user_password").on("ajax:success", (event, xhr) => {
  const { score } = xhr;
  const suggestions = xhr.suggestions.length
    ? xhr.suggestions
    : "Choose a password that is harder to guess";

  if (score < 4) {
    $("#password").addClass("govuk-form-group--error");
    $("#password")
      .find("input")
      .addClass("govuk-input--error");
    $(".govuk-error-message")
      .css("display", "inline-block")
      .html(`<span class="govuk-visually-hidden">Error:</span> ${suggestions}`);
  } else {
    $("#password").removeClass("govuk-form-group--error");
    $("#password")
      .find("input")
      .removeClass("govuk-input--error");
    $(".govuk-error-message").css("display", "none");
  }
});

$("#user_password_visibility_toggle").click(handleVisibilityButton);
$("#user_password_confirmation_visibility_toggle").click(handleVisibilityButton);

function handleVisibilityButton(clickEvent) {
  const buttonId = clickEvent.target.id;
  const visibilityTargetId = ("user_password_visibility_toggle" == buttonId) ? "user_password" : "user_password_confirmation";
  toggleVisibility(buttonId, visibilityTargetId);
}

function toggleVisibility(buttonId, targetElementId) {
  const button = $("#" + buttonId);
  const targetElement = $("#" + targetElementId);
  if (button.text() == "Show") {
    targetElement.attr("type", "text");
    button.html("Hide");
  } else {
    targetElement.attr("type", "password");
    button.html("Show");
  }
}
