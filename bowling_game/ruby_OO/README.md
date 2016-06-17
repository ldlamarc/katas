# Ruby Object Oriented implementation

Analysis of implementation

## Object Oriented Design:

### Pros:

- Objects are easy to understand (Roll, Frame, Game, RollBonus).
- Small objects are easy to extend. Features can easily be added upon the objects.

### Cons:

- Mutability
- Extra class per object

## NullObject Pattern:

### E.g.:

Bonus.null

### Pros:

- Interchangeability
- NullObject (e.g. NoBonus) is less generic and more meaningfull than nil
- Makes public code easier and more compact

```ruby
def score
  pins + generated_bonus.bonus_score # instead of: score = score; score += generated_bonus.bonus_score unless generated_bonus.nil?
end
```

### Cons:

- Adds extra lines of code in private classes/methods (declaration of NoBonus class)
