
type concrete = (int, int, int, option(string));

type raw = [
  | `Any
  | `Or(raw, raw)
  | `And(raw, raw)
  | `Between(raw, raw)
  | `LessThan(raw)
  | `AtMost(raw)
  | `GreaterThan(raw)
  | `AtLeast(raw)
  | `Exactly(concrete)
  | `UpToMinor(concrete)
  | `UpToMajor(concrete)
];

