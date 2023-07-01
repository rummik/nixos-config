# to run these tests:
# nix-instantiate --eval --strict __helpers_tests__.nix
# if the resulting list is empty, all tests passed
with import <nixpkgs> {}; let
  helpers = import ./helpers.nix { inherit lib; };
in
  lib.runTests {
    testFilterEmptyAttrs = {
      expr = helpers.filterEmptyAttrs {
        a = null;
        b = {};
        c = {
          d = null;
          e = {};
        };
      };
      expected = {};
    };

    testToLua = {
      expr = helpers.toLua' { multiline = false; } {
        foo = "bar";
        qux = [ 1 2 3 ];
      };
      expected = ''{ ["foo"] = "bar", ["qux"] = { 1, 2, 3 } }'';
    };

    testToLuaWithLambda = {
      expr = helpers.toLua {
        foo = "bar";
        qux = [ 1 2 3 ];
        zot = helpers.mkLuaLambda "return 1";
      };
      expected = ''{ ["foo"] = "bar", ["qux"] = { 1, 2, 3 }, ["zot"] = function() return 1 end }'';
    };

    testToLuaNestedAttrs = {
      expr = helpers.toLua {
        a = {
          b = 1;
          c = 2;
          d = { e = 3; };
        };
      };
      expected = ''{ ["a"] = { ["b"] = 1, ["c"] = 2, ["d"] = { ["e"] = 3 } } }'';
    };

    testToLuaNestedList = {
      expr = helpers.toLua [ 1 2 [ 3 4 [ 5 6 ] ] 7 ];
      expected = "{ 1, 2, { 3, 4, { 5, 6 } }, 7 }";
    };

    testToLuaNonStringPrims = {
      expr = helpers.toLua {
        a = 1.0;
        b = 2;
        c = true;
        d = false;
        e = null;
      };
      expected = ''{ ["a"] = 1.000000, ["b"] = 2, ["c"] = true, ["d"] = false, ["e"] = nil }'';
    };

    testToLuaStringPrim = {
      expr = helpers.toLua ''
        foo\bar
        baz'';
      expected = ''"foo\\bar\nbaz"'';
    };

    testToLuaLuaTableMixedAttrsList = {
      expr = helpers.toLuaObject {
        "@...." = "foo";
        bar = "baz";
      };
      expected = ''{ "foo", ["bar"] = "baz" }'';
    };

    testToLuaObjectShouldFilterNullAndEmptyAttrs = {
      expr = helpers.toLuaObject {
        a = null;
        b = {};
        c = {
          d = null;
          e = {};
        };
      };
      expected = "{}";
    };

    testToLuaObjectWithLuaLambda = {
      expr = helpers.toLuaObject {
        a = helpers.mkLuaLambda "return 1";
      };
      expected = ''{ ["a"] = function() return 1 end }'';
    };

    testToLua' = {
      expr = helpers.toLua' { multiline = true; } {
        foo = "bar";
        "@" = "baz";
        qux = [ 1 2 3 ];
      };
      expected = ''
        {
          "baz",
          ["foo"] = "bar",
          ["qux"] = { 1, 2, 3 }
        }'';
    };

    testCamelToSnake = {
      expr = helpers.camelToSnake "fooBarBaz";
      expected = "foo_bar_baz";
    };

    testCamelToSnakeAttrs = {
      expr =  helpers.camelToSnakeAttrs {
        fooBarBaz = 1;
        qux = 2;
      };
      expected = {
        foo_bar_baz = 1;
        qux = 2;
      };
    };

    testMkPluginSetupCall = {
      expr = helpers.mkPluginSetupCall "plugin" { option = true; };
      expected = ''
        require("plugin").setup({
          ["option"] = true
        })'';
    };
  }
