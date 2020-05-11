{ lib }:
with builtins; rec {
  mkFilter = { query, tags, message }: ''
    query = ${query}
    tags = ${concatStringsSep ";" tags}
    message = ${message}'';
  mkFilters = filters:
    lib.concatImapStrings (pos: f: ''
      [Filter.${toString pos}]
      ${f}
    '') filters;
  mkMoveToFolder = folder: [ "-new" "+${folder}" ];
  mkQFrom = from: ''from:"${from}"'';
  mkQTo = to: ''to:"${to}"'';
  mkQCC = cc: ''cc:"${cc}"'';
  mkQSub = sub: ''subject:"${sub}"'';
  mkQTag = tag: ''tag:"${tag}"'';
  mkQAnd = a: b: "${a} and ${b}";
  mkQOr = a: b: "${a} or ${b}";
  # Noise filter.
  mkSpamLike = initialTags:
    mkFilter {
      # compute ((((((x_1 or x_2) or x_3) or x_4) …) or x_n
      query = lib.foldl (x: y: mkQOr (mkQTag y) x) (mkQTag (head initialTags))
        (tail initialTags);
      tags = [ "+spamlike" "-new" ];
      message = "Spam-like filter";
    };
}
