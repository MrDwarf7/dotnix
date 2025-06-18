{lib}:
with builtins;
with lib; rec {
  # entries :: attrs -> [ { name, value } ]
  entries = attrsToList;

  # Compatibility shim, remove once call-sites migrated
  entries' = attrs:
    map (e: {
      key = e.name;
      inherit (e) value;
    }) (attrsToList attrs);

  ## Previous version from utils.nix file
  # entries = attrs:
  #   map (key: {
  #     key = key;
  #     value = attrs.${key};
  #   }) (attrNames attrs);

  # attrsToList :: attrs -> attrs
  # Example:
  # startAttrs = { a = 1; b = 2; }; -> [ { n = name = "a"; value = 1; }
  # [{fieldOne = "a"; fieldTwo = 1} {fieldOne = "b"; fieldTwo = 2}]
  # # where fieldOne is the name and fieldTwo is the value
  attrsToList = attrs:
    mapAttrsToList (name: value: {inherit name value;}) attrs;

  innerMapping = attrs: keyT: valueT: key: let
    entry = {
      key = key;
      value = attrs.${key};
    };
  in {
    name = keyT entry;
    value = valueT entry;
  };

  # transformAttrs ::
  #   attrs
  #   -> ({ name, value } -> string)    # keyTransform
  #   -> ({name, value } -> any)        # valueTransform
  #   -> attrs
  transformAttrs = attrs: keyT: valueT:
    listToAttrs (
      /*
      key inferred from current map idx
      */
      map (innerMapping attrs keyT valueT) (attrNames attrs)
    );

  ## Previous verison from utils.nix file
  # transformAttrs = attrs: keyTransform: valueTransform:
  #   listToAttrs (
  #     map (key: let
  #       entry = {
  #         key = key;
  #         value = attrs.${key};
  #       };
  #     in {
  #       name = keyTransform entry;
  #       value = valueTransform entry;
  #     }) (attrNames attrs)
  #   );

  # indent :: string -> string
  indent = text:
    lib.concatStringsSep
    "\n"
    (map (x: "   ${x}") (lib.splitString "\n" text));

  # mapFilterAttrs ::
  #   (name -> value -> bool)
  #   (name -> value -> { name = any; value = any; })
  #   attrs
  #   -> attrs
  mapFilterAttrs = f: pred: attrs: filterAttrs pred (mapAttrs f attrs);
  mapFilterAttrs' = f: pred: attrs: filterAttrs pred (mapAttrs' f attrs);

  # filterMapAttrs ::
  #   (name -> value -> { name = any; value = any; })
  #   (name -> value -> bool)
  #   attrs
  #   -> attrs
  filterMapAttrs = pred: f: attrs: (mapAttrs f (filterAttrs pred attrs));
  filterMapAttrs' = pred: f: attrs: (mapAttrs' f (filterAttrs pred attrs));

  # Generate an attribute set by mapping a function over a list of values.
  # genAttrs' :: list -> ((any -> any) -> attrs) -> attrs
  genAttrs' = values: f: listToAttrs (map f values);

  # anyAttrs :: (name -> value -> bool) attrs -> bool
  anyAttrs = pred: attrs:
    any (attr: pred attr.name attr.value) (attrsToList attrs);

  # countAttrs :: (name -> value -> bool) attrs -> int
  countAttrs = pred: attrs:
    count (attr: pred attr.name attr.value) (attrsToList attrs);

  # Unlike //, this will deeply merge attrsets (left > right).
  # mergeAttrs' :: listOf attrs -> attrs
  mergeAttrs' = attrList: let
    f = attrPath:
      zipAttrsWith (n: values:
        if (tail values) == []
        then head values
        else if all isList values
        then concatLists values
        else if all isAttrs values
        then f (attrPath ++ [n]) values
        else last values);
  in
    f [] attrList;

  # flattenAttrs :: (tree -> attrs) -> attrs
  # Credit goes to numtide/flake-utils for this!
  flattenAttrs = tree: let
    op = sum: path: val: let
      pathStr = concatStringsSep "/" path;
    in
      if (typeOf val) != "set"
      then
        # ignore that value
        # trace "${pathStr} is not of type set"
        sum
      else if val ? type && val.type == "derivation"
      then
        # trace "${pathStr} is a derivation"
        # we used to use the derivation outPath as the key, but that crashes Nix
        # so fallback on constructing a static key
        (sum // {${pathStr} = val;})
      else if val ? recurseForDerivations && val.recurseForDerivations == true
      then
        # trace "${pathStr} is a recursive"
        # recurse into that attribute set
        (recurse sum path val)
      else
        # ignore that value
        # trace "${pathStr} is something else"
        sum;
    recurse = sum: path: val:
      foldl'
      (sum: key: op sum (path ++ [key]) val.${key})
      sum
      (attrNames val);
  in
    recurse {} [] tree;
}
#
#### utils.nix contents before rem
# {lib}:
# with builtins;
# {
#   entries = attrs:
#     map (key: {
#       key = key;
#       value = attrs.${key};
#     }) (attrNames attrs);
#
#   transformAttrs = attrs: keyTransform: valueTransform:
#     listToAttrs (
#       map (key: let
#         entry = {
#           key = key;
#           value = attrs.${key};
#         };
#       in {
#         name = keyTransform entry;
#         value = valueTransform entry;
#       }) (attrNames attrs)
#     );
#
#   indent = text:
#     lib.concatStringsSep
#     "\n"
#     (map (x: "   ${x}") (lib.splitString "\n" text));
# }

