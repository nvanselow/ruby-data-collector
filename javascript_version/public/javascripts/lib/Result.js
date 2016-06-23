var Result = function(endTime, behaviors, responses){
  var currentResult = this;
  this.durationInMin = (endTime / 60).toFixed(2);
  this.behaviors = behaviors;
  this.responses = responses;

  this.behaviors.forEach(function(behavior){
    behavior.rate = (behavior.frequency / currentResult.durationInMin).toFixed(2);
  });
};
