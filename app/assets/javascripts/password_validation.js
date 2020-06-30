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
  const scoreClassification = score < 2 ? 'weak' : (score < 3 ? 'good' : 'excellent');
  return `
    Password strength:
    <span class="password-strength-score score-${scoreClassification}">${scoreClassification}</span>
  `;
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
  const { detail: [data] } = event;
  if (!data || typeof data !== 'object') return;
  const { score, suggestions } = data;
  if (typeof score !== 'number') return;
  updateScore(score);
  if (score < 2) {
    updateError(suggestions);
    return;
  }
  removeError();
});

$('#user_password_visibility_toggle').click(onVisibilityButtonToggle);
$('#user_password_confirmation_visibility_toggle').click(onVisibilityButtonToggle);

function onVisibilityButtonToggle(clickEvent) {
  const buttonId = clickEvent.target.id;
  const visibilityTargetId = 'user_password_visibility_toggle' === buttonId
    ? 'user_password'
    : 'user_password_confirmation';
  toggleVisibility(buttonId, visibilityTargetId);
}

function toggleVisibility(buttonId, targetElementId) {
  const button = $('#' + buttonId);
  const targetElement = $('#' + targetElementId);
  if (button.text() === 'Show') {
    targetElement.attr('type', 'text');
    button.html('Hide');
  } else {
    targetElement.attr('type', 'password');
    button.html('Show');
  }
}
