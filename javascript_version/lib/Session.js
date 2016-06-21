var Session = function(durationInMin){
  this.durationInMin = durationInMin;
  this.durationInSeconds = durationInMin * 60;
  this.behaviors = [];
  this.currentTime = 0;
  this.timerId = null;
  this.endTime = 0;
  this.responses = [];
  this.running = false;

  this.addBehavior = function(behavior){
    if(behavior){
      this.behaviors.push(behavior);
    }
  };

  this.removeBehavior = function(behavior){
    if(behavior){
      var index = this.behaviors.indexOf(behavior);
      this.behaviors.splice(index, 1);
    }
  };

  this.track = function(key){
    if(key){
      key = key.toLowerCase();
      if(key == 'q' || key == 'quit'){
        return this.end();
      }

      var selectedBehaviors = this.behaviors.filter(function(behavior){
        return behavior.key == key;
      });

      if(selectedBehaviors.length > 0){
        var selectedBehavior = selectedBehaviors[0];
        selectedBehavior.increment();
        this.responses.push(new Response(selectedBehavior, this.currentTime));
        return selectedBehavior;
      } else {
        return 'Behavior does not exist. Try a different key.';
      }
    }
  };

  this.start = function(){
    this.startTimer();
    this.running = true;
  };

  this.end = function(){
    this.stopTimer();
    this.running = false;
    this.endTime = this.currentTime;
  };

  this.startTimer = function(){
    this.timerId = setInterval(this.tick, 1000);
  };

  this.stopTimer = function(){
    clearInterval(this.timerId);
  };

  this.tick = function(){
    this.currentTime++;
    if(this.currentTime >= this.durationInSeconds){
      this.end();
    }
  };

  this.results = function(){
    return new Result(this.durationInMin, this.behaviors, this.responses);
  };
};