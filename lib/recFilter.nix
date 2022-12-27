{lib,
traceRecFilter ? false,
...}: let

traceval = v: (if traceRecFilter then builtins.trace v v else v);
tracemsg = msg: v: (if traceRecFilter then builtins.trace msg v else v);
toString = v: if builtins.isAttrs v then "(attrset)" else builtins.toString v;

setUnchangedAttributesToNull = attrs: base: (lib.attrsets.mapAttrsRecursive
    (_path: _value:
      let
        path = tracemsg "enter filter for ${toString _path} = ${toString _value}" _path;
        value = _value;
      in if (lib.attrsets.hasAttrByPath path base) then let
        baseValue = lib.attrsets.getAttrFromPath path base;
      in
        if tracemsg "exists in base = ${toString baseValue}" traceval (value != baseValue)
        then # not equal, keep this value
          value
        else # equal, replace with null.
          null
      else
        tracemsg "not in base." value
    ) attrs);

removeNullAttributesFromSet = attrs: lib.attrsets.filterAttrsRecursive 
  (_n: v:
    if builtins.isAttrs v then
      v != {}
    else
      v != null)
attrs;

in value: base:
  # need to take multiple passes to remove null attributes, because attribute sets containing a null will become { } on first pass.
  # just.. do it three times, that should be enough depth for kde config
  removeNullAttributesFromSet (removeNullAttributesFromSet (removeNullAttributesFromSet (setUnchangedAttributesToNull value base)))
