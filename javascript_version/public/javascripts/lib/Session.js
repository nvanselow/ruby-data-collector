var Session = function(durationInMin){
  this.durationInMin = durationInMin;
  this.behaviors = [];
  this.currentTime = 0;
  this.timerId = null;
  this.callbackTimerId = null;
  this.endTime = 0;
  this.responses = [];
  this.running = false;
  this.completeCallback = null;

  this.durationInSeconds = function(){
    return this.durationInMin * 60;
  };

  this.addBehavior = function(behavior){
    if(behavior){
      this.behaviors.push(behavior);
    }
  };

  this.removeBehavior = function(behavior){
    if(behavior){
      var index = this.behaviors.indexOf(behavior);
      if(index > 0){
        this.behaviors.splice(index, 1);
      }
    }
  };

  this.removeBehaviorByName = function(name){
    if(name){
      for(var i = 0; i < this.behaviors.length; i++){
        if(this.behaviors[i].name === name){
          this.behaviors.splice(i, 1);
        }
      }
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
        return null;
      }
    }
  };

  this.start = function(timerCallback, completeCallback){
    this.startTimer(timerCallback);
    this.running = true;
    if(completeCallback){
      this.completeCallback = completeCallback;
    }
  };

  this.end = function(){
    this.stopTimer();
    this.running = false;
    this.endTime = this.currentTime;
    if(this.completeCallback){
      this.completeCallback();
    }
  };

  this.startTimer = function(callback){
    // need this craziness to maintain context for tick function
    this.timerId = setInterval((
      function(self){
        return function(){ self.tick(); };
      })(this),
      1000);
    if(callback){
      this.callbackTimerId = setInterval(callback, 1000);
    }
  };

  this.stopTimer = function(){
    clearInterval(this.timerId);
    clearInterval(this.callbackTimerId);
  };

  this.tick = function(){
    this.currentTime++;
    if(this.currentTime >= this.durationInSeconds()){
      this.end();
    }
  };

  this.results = function(){
    return new Result(this.endTime, this.behaviors, this.responses);
  };
};
