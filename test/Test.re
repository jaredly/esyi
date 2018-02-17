
let module Suites = {
  include Fetch;
  include Solve;
  include Npm.ParseNpm;
};

/* Src.Something.getNums("awe123", 1); */
print_endline("Hello");
TestRe.report();
