var session = new Session(5);

var addBehaviorToList = function(behavior){
  var name = $('<h5>', {class: "behavior-name", text: behavior.name});
  var key = $('  <h5>("<span class="behavior-key">' + behavior.key +'</span>")</h5>');
  var descriptionLabel = $('<span>', {text: "Description:"});
  var description = $('<p>', {class: "behavior-description", text: behavior.description});
  var wrappingDiv = $('<div>', {class: "behavior columns small-12 medium-6"});
  var row = $('<div>', {class: "row"});
  var nameColumn = $('<div>', {class: "columns small-10"});
  var buttonColumn = $('<div>', {class: "columns small-2"});
  var deleteButton = $('<button>', {class: "button alert small delete-button", text: "Delete"});

  nameColumn.append(name, key);
  buttonColumn.append(deleteButton);
  row.append(nameColumn, buttonColumn);
  var behaviorDiv = wrappingDiv.append(row, descriptionLabel, description);

  $("#behavior-list").append(behaviorDiv);
  deleteButton.click(removeBehavior);
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

$(document).ready(function(){
  $("#add-behavior-button").click(addBehavior);
  // $(".delete-button").click(removeBehavior);
});
