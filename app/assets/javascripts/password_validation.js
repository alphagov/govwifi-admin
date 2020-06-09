const getPasswordStrength = password => {
  const result = zxcvbn(password);
  const score = 100 * result.score / 4;
  const scoreText = score < 50 ? "weak" : score < 100 ? "medium" : "good";
  const rawSuggestion = result.feedback.suggestions.join(", ");
  // zxcvbn-js sometimes fails to return a suggestion even when the password is too weak, so we need to perform some coercion.
  const suggestion = !rawSuggestion
    ? "Choose a password that is harder to guess"
    : rawSuggestion;
  return { score, scoreText, suggestion };
};

if ($('input[name="user[password]"]').length) {
  $("body").on("blur", 'input[name="user[password]"]', function(e) {
    const { score, suggestion } = getPasswordStrength(this.value);
    if (this.value.length && score < 100) {
      $("#password").addClass("govuk-form-group--error");
      $("#password")
        .find("input")
        .addClass("govuk-input--error");
      $(".govuk-error-message")
        .css("display", "inline-block")
        .html(
          `<span class="govuk-visually-hidden">Error:</span> ${suggestion}`
        );
    } else {
      $("#password").removeClass("govuk-form-group--error");
      $("#password")
        .find("input")
        .removeClass("govuk-input--error");
      $(".govuk-error-message").css("display", "none");
    }
  });
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
