var Behavior = function(name, key, description){
  this.name = name;
  this.key = key.toLowerCase();
  this.description = description;
  this.frequency = 0;
  this.rate = null;

  this.increment = function(amount){
    if(!amount) { amount = 1; }
    this.frequency += amount;
  };
};
