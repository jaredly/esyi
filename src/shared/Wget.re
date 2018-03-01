
let init = () => Curl.global_init(Curl.CURLINIT_GLOBALSSL);

let cleanup = () => Curl.global_cleanup();

let get = url => {
  /* print_endline("Wget " ++ url);
  let t = Curl.init();
  print_endline("Wget " ++ url);
  Curl.set_url(t, url);
  let data = ref("");
  Curl.set_writefunction(t, newData => {
    data := data^ ++ newData;
    print_endline("Data");
    String.length(newData);
  });
  Curl.perform(t);
  print_endline("Got");
  let response = Curl.getinfo(t, Curl.CURLINFO_HTTP_CODE);
  Curl.cleanup(t);
  switch (response) {
  | Curl.CURLINFO_Long(200) => {
    Some(data^)
  }
  | Curl.CURLINFO_Long(num) => {
    print_endline("Url response " ++ url ++ " was " ++ string_of_int(num));
    None
  }
  | _ => failwith("bad curl result")
  }; */
  let (lines, good) = ExecCommand.execSync(~cmd="curl -s -f -L " ++ url, ());
  if (good) {
    Some(String.concat("\n", lines))
  } else {
    None
  }
}