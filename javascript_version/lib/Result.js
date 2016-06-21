var Result = function(durationInMin, behaviors, responses){
  this.durationInMin = durationInMin;
  this.behaviors = behaviors;
  this.responses = responses;

  this.behaviors.forEach(function(behavior){
    behavior.rate = (behavior.frequency / this.durationInMin).toFixed(2); 
  });
};
