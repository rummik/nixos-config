map
  ({ prefix, path }: {
    meta = {};
    name = prefix;
    outPath = path;
    out.outPath = path;
    outputs = [ "out" ];
    system = "x86_64-linux";
    type = "derivation";
  })
  (import ./.).__nixPath
