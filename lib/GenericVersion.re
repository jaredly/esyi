
type range('inner) =
  | Or(range('inner), range('inner))
  | And(range('inner), range('inner))
  | Exactly('inner)
  | GreaterThan('inner)
  | AtLeast('inner)
  | LessThan('inner)
  | AtMost('inner)
  | Any;
  /* | UntilNextMajor('concrete) | UntilNextMinor('concrete); */

let rec matches = (compareInner, range, concrete) => {
  switch range {
  | Exactly(a) => compareInner(a, concrete) == 0
  | Any => true
  | GreaterThan(a) => compareInner(a, concrete) < 0
  | AtLeast(a) => compareInner(a, concrete) <= 0
  | LessThan(a) => compareInner(a, concrete) > 0
  | AtMost(a) => compareInner(a, concrete) >= 0
  | And(a, b) => matches(compareInner, a, concrete) && matches(compareInner, b, concrete)
  | Or(a, b) => matches(compareInner, a, concrete) || matches(compareInner, b, concrete)
  }
};