describe("Behavior", function(){
  var name, key, description, behavior;

  beforeEach(function(){
    name = 'Aggression';
    key = 'a';
    description = 'Actual or attempted physical contact with another person.';
    behavior = new Behavior(name, key, description);
  });

  describe(".new", function(){
    it("creates a new instance of Behavior", function(){
      expect(behavior instanceof Behavior).toBe(true);
    });
  });

  describe(".name", function(){
    it("returns the name of the behavior", function(){
      expect(behavior.name).toEqual(name);
    });
  });

  describe(".key", function(){
    it("returns the key of the behavior", function(){
      expect(behavior.key).toEqual(key);
    });

    it("is always lowercase", function(){
      behavior = new Behavior(name, "M", description);

      expect(behavior.key).toEqual('m');
    });
  });

  describe(".description", function(){
    it("returns the description of the behavior", function(){
      expect(behavior.description).toEqual(description);
    });

    it("returns undefined if the description is not available", function(){
      var behaviorMissingDescription = new Behavior(name, key);

      expect(behaviorMissingDescription.description).toEqual(undefined);
    });
  });

  describe(".frequency", function(){
    it("has a reader for the frequency of the behavior", function(){
      expect(behavior.frequency).toEqual(0);
    });
  });

  describe(".incremenet", function(){
    it("increments the frequency by 1 with no arguments", function(){
      behavior.increment();

      expect(behavior.frequency).toEqual(1);
    });

    it("increments the frequency by the argument provided", function(){
      behavior.increment(5);

      expect(behavior.frequency).toEqual(5);
    });
  });

});
