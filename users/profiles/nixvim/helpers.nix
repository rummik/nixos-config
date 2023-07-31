{ lib, ... }:
let
  inherit (lib)
    boolToString
    concatMapStringsSep
    concatStringsSep
    filterAttrsRecursive
    mapAttrs
    mapAttrs'
    mapAttrsToList
    nameValuePair
    stringToCharacters
    ;

  inherit (lib.strings)
    isCoercibleToString
    lowerChars
    replaceStrings
    upperChars
    ;

  inherit (builtins)
    elem
    hasAttr
    substring
    ;

in
rec {
  inherit (lib.types) isType setType;
  inherit (builtins) isAttrs isBool isFloat isInt isList isNull isPath isString typeOf;

  camelToSnake = replaceStrings upperChars (map (s: "_${s}") lowerChars);

  camelToSnakeAttrs =
    mapAttrs' (
      name: value:
        nameValuePair
          (camelToSnake name)
          (if isAttrs value
           then camelToSnakeAttrs value
           else value)
    );

  isLua = isType "lua";
  isLuaFunction = x: isLua x && x._lua_type == "function";

  setLuaType = type: value: mkLua value // { _lua_type = type; };

  # Mark a string as a lua expression.
  #
  # Example:
  #   mkLua "vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>')"
  #   => { _type = "lua"; value = "vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>')"; }
  mkLua = value:
    setType "lua" {
      value =
        if isString value
        then value
        else if isCoercibleToString value
        then toString value
        else throw "mkLua: expected a string, got ${value}";
    };

  mkLuaFunction = argstr: body: mkLua "function(${argstr}) ${body} end";
  mkLuaNamedFunction = name: argstr: body: mkLua "function ${name}(${argstr}) ${body} end";
  mkLuaLambda = body: mkLuaFunction "" body;
  mkLuaCall = name: args: mkLua "${name}(${concatMapStringsSep ", " toLua args})";

  # Generate setup call for a plugin.  This uses `toLuaObject` to generate the
  # options table, which filters out null and empty values.
  #
  # Example:
  #   mkPluginSetupCall "plugin" { option = true; }
  #   => ''require("plugin").setup({ ["option"] = true })''
  mkPluginSetupCall = plugin: options: ''require("${plugin}").setup(${toLuaObject' {} options})'';

  # Quote a string for use in Lua.
  #
  # For now this is just a wrapper around toJSON, which may have an edge case
  # if the string contains a unicode character that needs to be represented as a
  # numeric escape sequence.  JSON uses \uHHHH, but Lua uses \ddd.
  #
  # Example:
  #   escapeLuaString "foo\nbar"
  #   => "\"foo\\nbar\""
  escapeLuaString = builtins.toJSON;

  # Returns a string containing a Lua representation of _x_.  Strings,
  # integers, floats, booleans, nulls, and lists, are mapped to their Lua
  # equivalents.  Attrsets are mapped to Lua tables with string keys, unless
  # the key is a string that starts with an `@`, in which case the key is
  # omitted.
  #
  # Example:
  #   toLua { foo = "bar"; "@" = "baz"; qux = [ 1 2 3 ]; }
  #   => ''{ ["foo"] = "bar", "baz", ["qux"] = { 1, 2, 3 } }''
  toLua = toLua' { multiline = false; };

  # Like `toLua`, but pretty prints the output.
  toLuaPretty = toLua' { multiline = true; };

  # Like `toLua`, but optionally generates pretty printed output.
  # Inspired by lib.generators.toPretty.
  #
  # Example:
  #   toLua' {} { foo = "bar"; "@" = "baz"; qux = [ 1 2 3 ]; }
  #   => ''{
  #     "baz",
  #     ["foo"] = "bar",
  #     ["qux"] = { 1, 2, 3 }
  #   }''
  toLua' = { multiline ? true }:
    let
      toLua'' = spaces': v: with builtins;
        let
          spaces = if multiline then "${spaces'}  " else "";
          indent = if multiline then "\n${spaces}" else " ";
          indent' = if multiline then "\n${spaces'}" else " ";
        in
        if isLua v
        then v.value
        else if isBool v
        then boolToString v
        else if isFloat v
        then toString v
        else if isInt v
        then toString v
        else if isNull v
        then "nil"
        else if isString v
        then escapeLuaString v
        else if isList v
        then
          if v == []
          then "{}"
          else "{ ${concatMapStringsSep ", " (toLua'' spaces) v} }"
        else if isCoercibleToString v
        then escapeLuaString (toString v)
        else if isAttrs v
        then
          if v == {}
          then "{}"
          else
            let
              mapper = k: v:
                if substring 0 1 k == "@"
                then toLua'' spaces v
                else "[${toLua'' spaces k}] = ${toLua'' spaces v}";
            in
            "{${indent}${concatStringsSep ",${indent}" (mapAttrsToList mapper v)}${indent'}}"
        else throw "toLua': unsupported type: ${typeOf v}";
      in toLua'' "";

  # Wrapper around `toLua` that filters out null values and empty lists in attrsets.
  #
  # Example:
  #   toLuaObject { foo = null; bar = []; baz = {}; qux = [ 1 2 3 ]; }
  #   => ''{ ["qux"] = { 1, 2, 3 } }''
  toLuaObject = toLuaObject' { multiline = false; };

  # Wrapper around `toLua'` that filters out null values and empty lists in attrsets.
  #
  # Example:
  #   toLuaObject' { multiline = false; } { foo = null; bar = []; baz = {}; qux = [ 1 2 3 ]; }
  #   => ''{ ["qux"] = { 1, 2, 3 } }''
  toLuaObject' = opts: x:
    if isAttrs x && !isLua x && !isCoercibleToString x
    then toLua' opts (filterEmptyAttrs x)
    else toLua' opts x;

  # Recursively filter out empty values (null, [], {}) from an attrset after.
  #
  # Example:
  #   filterEmptyAttrs { foo = null; bar = []; baz = {}; qux = [ 1 2 3 ]; }
  #   => { qux = [ 1 2 3 ]; }
  filterEmptyAttrs =
    lib.converge (filterAttrsRecursive (_: v: !elem v [ null [] {} ]));

  mkNvimKeymapCall = fnName: {
    mode ? "n",
    lhs,
    rhs,
    opts ? {},
  }:
    mkLuaCall fnName [ mode lhs rhs opts ];

  mkNvimKeymap = mkNvimKeymapCall "vim.keymap.set";

  normalizeVimKeymapModes =
    let
      vimShortKeyModes = [ "" ] ++ stringToCharacters "n!icvxsotl";

      vimLongKeyModes = {
        normalVisualOp = "";
        normal = "n";
        insertCommand = "!";
        insert = "i";
        command = "c";
        visual = "v";
        visualOnly = "x";
        select = "s";
        operator = "o";
        terminal = "t";
        lang = "l";
      };
    in
    mode:
      if hasAttr mode vimLongKeyModes
      then vimLongKeyModes.${mode}
      else if builtins.elem mode vimShortKeyModes
      then mode
      else throw "normalizeVimKeymapModes: invalid key mode: ${mode}";

  # Returns a string containing a Neovim Lua API keymap definition for the given keymap.
  #
  # Expected input follows the following format:
  #   { <mode>.<lhs> = <rhs> or { rhs = <rhs>; opts = <opts>; }; ... }
  #
  # Where _mode_ is a string containing single-character Neovim keymap modes,
  # _lhs_ is a string, _rhs_ is a string or a Lua type, and _opts_ is an
  # attrset containing keymap options.
  #
  # See Nevoim help for nvim_set_keymap() for a description of modes and options.
  #
  # Type: attrsToNvimKeymap :: attrs -> string
  #
  # Example:
  #   mkNvimKeymaps { "nv"."<leader>hD" = mkLuaLambda "_.diffthis('~')"; }
  #   => ''vim.keymap.set({ "n", "v" }, "<leader>hD", function() _.diffthis('~') end)''
  #   mkNvimKeymaps { "n"."]c" = [ "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'" { expr = true } ]; }
  #   => ''vim.keymap.set("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })''
  mkNvimKeymaps = attrs:
  # TODO: check that each character is a valid mode
  # TODO: check that each character is unique
  # TODO: support full mode names
    mapAttrs (_mode: maps: let
      mode = stringToCharacters _mode;
    in
      mapAttrs (
        lhs: rhs:
          mkLuaCall "vim.keymap.set" ([ mode lhs ]
            ++ (
              if isAttrs rhs
              then [ rhs.rhs rhs.opts ]
              else [ rhs ]
            ))
        # if (isAttrs rhs) && (hasAttr "opts" rhs) then
        #   mkLuaCall "vim.keymap.set" [mode lhs rhs.rhs rhs.opts]
        # else
        #   mkLuaCall "vim.keymap.set" [mode lhs rhs]
      )
      maps)
    attrs;
}
