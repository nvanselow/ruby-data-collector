var session = new Session(5);

$(document).ready(function(){
  $('#run-session').hide();
  $('#results').hide();
  $("#new-session-error").hide();
  $("#add-behavior-button").click(addBehavior);
  $("#new-session-form").submit(startSession);
});

var showFormError = function(text){
  var error = $('#new-session-error');
  error.text(text);
  error.fadeIn();
};

var hideFormError = function(){
  $('#new-session-error').hide();
};

var createBaseBehavior = function(behavior, add_buttons){
  var name = $('<h5>', {class: "behavior-name", text: behavior.name});
  var key = $('  <h5>("<span class="behavior-key">' + behavior.key +'</span>")</h5>');
  var descriptionLabel = $('<span>', {text: "Description:"});
  var description = $('<p>', {class: "behavior-description", text: behavior.description});
  var wrappingDiv = $('<div>', {class: "behavior columns small-12 medium-6"});
  var nameColumn = $('<div>', {class: "columns small-10"});
  var row = $('<div>', {class: "row"});

  nameColumn.append(name, key);
  row.append(nameColumn);

  var deleteButton;
  if(add_buttons){
    var buttonColumn = $('<div>', {class: "columns small-2"});
    deleteButton = $('<button>', {class: "button alert small delete-button", text: "Delete"});
    buttonColumn.append(deleteButton);
    row.append(buttonColumn);
  }

  var behaviorDiv = wrappingDiv.append(row, descriptionLabel, description);

  if(add_buttons){
    return {behaviorDiv: behaviorDiv, deleteButton: deleteButton};
  } else {
    return behaviorDiv;
  }
};

var addBehaviorToList = function(behavior){
  var html = createBaseBehavior(behavior, true);

  $("#behavior-list").append(html.behaviorDiv);
  html.deleteButton.click(removeBehavior);
};

var clearBehaviorForm = function(){
  $("#behavior-name").val("");
  $("#behavior-key").val("");
  $("#behavior-description").val("");
};

var addBehavior = function(event){
  event.preventDefault();

  var name = $("#behavior-name").val();
  var key = $("#behavior-key").val();
  var description = $("#behavior-description").val();

  var newBehavior = new Behavior(name, key, description);

  session.addBehavior(newBehavior);
  addBehaviorToList(newBehavior);
  clearBehaviorForm();
  $('#no-behavior-message').hide();
};

var removeBehavior = function(event){
  event.preventDefault();
  event.stopPropagation();

  var behaviorElement = $(event.target).closest(".behavior");
  var name = behaviorElement.find('.behavior-name').text();
  var key = behaviorElement.find('.behavior-key').text();
  var description = behaviorElement.find('.behavior-description').text();

  session.removeBehaviorByName(name);
  behaviorElement.remove();

  if(session.behaviors.length === 0){
    $('#no-behavior-message').show();
  }
};

var validSession = function(){
  if(!session.durationInMin){
    showFormError("Please enter a session duration.");
    return false;
  }

  if(session.behaviors.length === 0){
    showFormError("Please enter at least one behavior.");
    return false;
  }

  return true;
};

var startSession = function(event){
  event.preventDefault();
  hideFormError();

  var sessionDuration = $('#session-duration').val();
  session.durationInMin = sessionDuration;

  if(validSession()){
    $('#new-session').hide();
    $('#run-session').show();
    $('.end').hide();
    prepareSession();
  }
};

var trackBehavior = function(event){
  var behavior = event.data.behavior;
  // behavior.increment();
  session.track(behavior.key);

  $('#frequency_' + behavior.key).text(behavior.frequency);
};

var trackBehaviorByKey = function(event){
  var behavior = session.track(event.key);

  if(behavior){
    $('#frequency_' + event.key).text(behavior.frequency);
  }
};

var prepareSession = function(){
  //Add basic session info
  $('#run-session-duration').text(session.durationInSeconds());
  $('#current-session-time').text(session.currentTime);

  //Add behaviors
  session.behaviors.forEach(function(behavior){
    frequencyDivHtml = '<div class="row">' +
      '<div class="columns small-12">' +
        'Frequency: <span id="frequency_' + behavior.key +'">0</span>' +
        '</div></div>';
    var frequency = $(frequencyDivHtml);
    var trackingButton = $('<button>', {id: 'track_' + behavior.key, class: 'button', text: 'Track Behavior ' + behavior.name});

    var behaviorDiv = createBaseBehavior(behavior);
    behaviorDiv.append(frequency, trackingButton);

    $('#session-behaviors').append(behaviorDiv);
    trackingButton.click({behavior: behavior}, trackBehavior);
  });

  $('#session-behaviors').addClass('disabled-div');
  $('#start-session-button').click(runSession);
};

var tick = function(){
  $('#current-session-time').text(session.currentTime);
};

var endSession = function(){
  $('#run-session').hide();

  showResults();
  $('#results').show();
};

var terminateSessionEarly = function(){
  session.end();
};

var runSession = function(event){
  event.preventDefault();

  $('#session-behaviors').removeClass('disabled-div');
  $('#current-session-time').text(session.currentTime);
  $('.start').hide();
  $('.end').show();
  $('#end-session-button').click(terminateSessionEarly);
  $('body').keypress(trackBehaviorByKey);
  session.start(tick, endSession);
};

var showResults = function(){
  var results = session.results();

  $('#planned-session-duration').text(session.durationInSeconds());
  $('#actual-session-duration').text(session.endTime);

  results.behaviors.forEach(function(behavior){
    var nameColumn = $('<td>', {text: behavior.name, class: "text-center"});
    var frequencyColumn = $('<td>', {text: behavior.frequency.toString(), class: "text-center"});
    var rateColumn = $('<td>', {text: behavior.rate.toString(), class: "text-center"});
    var behaviorRow = $('<tr>');
    behaviorRow.append(nameColumn, frequencyColumn, rateColumn);
    $('#behavior-results').append(behaviorRow);
  });

  session.responses.forEach(function(response){
    var timeColumn = $('<td>', {text: response.time, class: "text-center"});
    var behaviorColumn = $('<td>', {text: response.behavior.name, class: "text-center"});
    var responseRow = $('<tr>');
    responseRow.append(timeColumn, behaviorColumn);
    $('#all-responses').append(responseRow);
  });
};
