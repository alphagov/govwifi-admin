const getSuggestionHtml = suggestions => {
  const headingHtml = `
    <span class="govuk-error-message govuk-!-margin-bottom-1">
        Choose a password that is harder to guess${suggestions.length ? ':' : ''}
    </span>
  `;
  const suggestionListHtml = `
    <ul class="govuk-error-message govuk-list govuk-list--bullet">
        ${suggestions.map(s => `<li>${s}</li>`).join('')}
    </ul>
  `;
  return suggestions.length ? `${headingHtml}${suggestionListHtml}` : headingHtml;
};

const getScoreHtml = score => {
  const scoreText = score < 2 ? 'weak' : (score < 4 ? 'medium' : 'good');
  return `Password strength: <span class="password-strength-score">${scoreText}</span>`;
};

const updateScore = score => $('.password-strength').html(getScoreHtml(score));

const updateError = suggestions => {
  $('#password').addClass('govuk-form-group--error');
  $('#password')
    .find('input')
    .addClass('govuk-input--error');
  $('.password-error-message')
    .css('display', 'inline-block')
    .html(`<span class="govuk-visually-hidden">Error:</span> ${getSuggestionHtml(suggestions)}`);
};

const removeError = () => {
  $('#password').removeClass('govuk-form-group--error');
  $('#password')
    .find('input')
    .removeClass('govuk-input--error');
  $('.govuk-error-message').css('display', 'none');
};

$('#user_password').on('ajax:success', event => {
  const detail = event.detail;
  const [data, status] = detail;
  if (!data || typeof data !== 'object' || status !== 'OK') return;
  const { score, suggestions } = data;
  if (typeof score !== 'number') return;
  updateScore(score);
  if (score < 4) {
    updateError(suggestions);
    return;
  }
  removeError();
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
