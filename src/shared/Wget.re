
let get = url => {
  Curl.global_init(Curl.CURLINIT_GLOBALSSL);
  let t = Curl.init();
  Curl.set_url(t, url);
  let data = ref("");
  Curl.set_writefunction(t, newData => {
    data := data^ ++ newData;
    String.length(newData);
  });
  Curl.perform(t);
  let response = Curl.getinfo(t, Curl.CURLINFO_HTTP_CODE);
  Curl.cleanup(t);
  Curl.global_cleanup();
  switch (response) {
  | Curl.CURLINFO_Long(200) => {
    Some(data^)
  }
  | Curl.CURLINFO_Long(num) => {
    print_endline("Url response " ++ url ++ " was " ++ string_of_int(num));
    None
  }
  | _ => failwith("bad curl result")
  };
}