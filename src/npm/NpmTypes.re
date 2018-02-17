
type raw = [
  | `Any
  | `Or(raw, raw)
  | `And(raw, raw)
  | `Between(raw, raw)
  | `LessThan(raw)
  | `AtMost(raw)
  | `GreaterThan(raw)
  | `AtLeast(raw)
  | `Exactly(Shared.Types.npmConcrete)
  | `UpToMinor(Shared.Types.npmConcrete)
  | `UpToMajor(Shared.Types.npmConcrete)
];

