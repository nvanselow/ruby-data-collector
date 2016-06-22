describe("Session", function(){
  var sessionDuration, session, behavior, actualSessionDuration, key;

  beforeEach(function(){
    sessionDuration = 5;
    session = new Session(sessionDuration);
    key = 'm';
    behavior = new Behavior('behavior', key);
    actualSessionDuration = (1 / 60).toFixed(2);
  });

  describe(".new", function(){
    it("creates a new session", function(){
      expect(session instanceof Session).toBe(true);
    });

    it("accepts a session duration in minutes on creation", function(){
      expect(session.durationInMin).toEqual(sessionDuration);
    });
  });

  describe(".durationInMin", function(){
    it("returns the duration of the session in minutes", function(){
      expect(session.durationInMin).toEqual(sessionDuration);
    });
  });

  describe(".addBehavior", function(){
    it("adds a behavior to the session", function(){
      session.addBehavior(behavior);

      expect(session.behaviors.length).toEqual(1);
      expect(session.behaviors[0]).toEqual(behavior);
    });
  });

  describe(".removeBehavior", function(){
    it("removes a behavior from the session", function(){
      session.addBehavior(new Behavior('distractor', 'm'));
      session.addBehavior(behavior);
      session.addBehavior(new Behavior('distractor 2', 'm'));
      session.addBehavior(new Behavior('distractor 3', 'm'));

      session.removeBehavior(behavior);

      expect(session.behaviors.length).toEqual(3);
      expect(session.behaviors).not.toContain(behavior);
    });

    it("tries to remove a behavior not on the list", function(){
      session.addBehavior(new Behavior('distractor', 'm'));
      session.addBehavior(new Behavior('distractor 2', 'm'));
      session.addBehavior(new Behavior('distractor 3', 'm'));

      session.removeBehavior(behavior);

      expect(session.behaviors.length).toEqual(3);
      expect(session.behaviors).not.toContain(behavior);
    });
  });

  describe(".removeBehaviorByName", function(){
    it("removes a behavior based on the name", function(){
      session.addBehavior(new Behavior('distractor', 'm'));
      session.addBehavior(behavior);
      session.addBehavior(new Behavior('distractor 2', 'm'));
      session.addBehavior(new Behavior('distractor 3', 'm'));

      session.removeBehaviorByName(behavior.name);

      expect(session.behaviors.length).toEqual(3);
      expect(session.behaviors).not.toContain(behavior);
    });

    it("does not remove any behaviors if the name does not match anything", function(){
      session.addBehavior(new Behavior('distractor', 'm'));
      session.addBehavior(new Behavior('distractor 2', 'm'));
      session.addBehavior(new Behavior('distractor 3', 'm'));

      session.removeBehaviorByName(behavior.name);

      expect(session.behaviors.length).toEqual(3);
      expect(session.behaviors).not.toContain(behavior);
    });
  });

  describe(".start", function(){
    it("starts the session timer", function(){
      session.startTimer = jasmine.createSpy("startTimer() spy");
      session.start();

      expect(session.startTimer).toHaveBeenCalled();
    });
  });

  describe(".endSession", function(){
    it("stops the session timer", function(){
      session.stopTimer = jasmine.createSpy("stopTimer() spy");

      session.end();

      expect(session.stopTimer).toHaveBeenCalled();
    });

    it("sets the end time", function(){
      session.currentTime = 30;

      session.end();

      expect(session.endTime).toEqual(30);
    });
  });

  describe(".tick", function(){
    it("increments the session timer", function(){
      session.tick();

      expect(session.currentTime).toEqual(1);
    });

    it("ends the session if the total duration has been reached", function(){
      session.end = jasmine.createSpy("end() spy");
      session.currentTime = session.durationInSeconds;

      session.tick();

      expect(session.end).toHaveBeenCalled();
    });
  });

  describe(".track", function(){
    beforeEach(function(){
      session.addBehavior(behavior);
    });

    it("accepts a key press as an argument", function(){
      session.track('m');

      expect(session.responses.length).toEqual(1);
    });

    it("increases the frequency of a behavior based on a key press", function(){
      session.track(key);

      expect(behavior.frequency).toEqual(1);
    });

    it("adds the tracked behavior to the responses", function(){
      session.track(key);

      expect(session.responses.length).toEqual(1);
      expect(session.responses[0].behavior).toEqual(behavior);
    });

    it("along with the time the key was pressed", function(){
      session.track(key);

      expect(session.responses.length).toEqual(1);
      expect(session.responses[0].time).toEqual(0);
    });

    it("returns the behavior is a valid key is pressed", function(){
      var response = session.track(key);

      expect(response).toEqual(behavior);
    });

    it("returns a message stating there is no behavior if an unknown letter is provided", function(){
      var response = session.track("unknown key");

      expect(response).toEqual("Behavior does not exist. Try a different key.");
    });

    it("calls the end function when the key is 'q'", function(){
      spyOn(session, "end");

      session.track('q');

      expect(session.end).toHaveBeenCalled();
    });

    it("calls the end function when the key is 'quit'", function(){
      spyOn(session, "end");

      session.track('quit');

      expect(session.end).toHaveBeenCalled();
    });

    it("calls the end function even if uppercased letters are used", function(){
      spyOn(session, "end");

      session.track('Q');

      expect(session.end).toHaveBeenCalled();
    });
  });

  describe(".running", function(){
    it("returns true if the session is running", function(){
      session.start();

      expect(session.running).toEqual(true);
    });

    it("returns false if the session has stopped", function(){
      session.start();
      session.end();

      expect(session.running).toEqual(false);
    });
  });

  describe(".results", function(){
    var behaviorFrequency = 3;
    var behaviorRate = (3 / sessionDuration).toFixed(2);
    var behavior2 = new Behavior("new beahvior", "key 2");
    var behavior2Frequency = 1;
    var behavior2Rate = (1 / sessionDuration).toFixed(2);

    beforeEach(function(){
      session.addBehavior(behavior);
      session.addBehavior(behavior2);

      session.track(behavior.key);
      session.track(behavior2.key);
      session.track(behavior.key);
      session.track(behavior.key);
    });

    it("returns a Result that includes the session duration", function(){
      expect(session.results().durationInMin).toEqual(sessionDuration);
    });

    it("returns a Result that includes a list of each behavior", function(){
      expect(session.results().behaviors).toContain(behavior);
      expect(session.results().behaviors).toContain(behavior2);
    });

    it("returns a Result that includes the rate of each beahvior", function(){
      expect(session.results().behaviors[0].rate).toEqual(behaviorRate);
      expect(session.results().behaviors[0].rate).toEqual(behavior2Rate);
    });
  });
});
