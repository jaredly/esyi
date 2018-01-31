
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
  Curl.cleanup(t);
  Curl.global_cleanup();
  data^
}