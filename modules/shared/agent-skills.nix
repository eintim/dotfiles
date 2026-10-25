{ inputs, ... }:
{
  flake.modules.homeManager.agent-skills =
    { lib, ... }:
    let
      # Skills keep their upstream folder name, which matches the name in
      # their SKILL.md and the name other skills refer to them by.
      skillsFrom =
        root: paths:
        map (path: {
          name = baseNameOf path;
          source = "${root}/${path}";
        }) paths;

      skills =
        skillsFrom "${inputs.anthropic-skills}/skills" [ "frontend-design" ]
        ++ skillsFrom "${inputs.mattpocock-skills}/skills" [
          "engineering/diagnosing-bugs"
          "engineering/wizard"
          "productivity/grill-me"
          # grill-me only hands off to grilling.
          "productivity/grilling"
          "productivity/writing-for-agents"
        ]
        ++ skillsFrom "${inputs.pstack-claude}/plugins/pstack/skills" [
          "blast-radius"
          "interrogate"
          "technical-writing"
          # Applied by technical-writing and blast-radius.
          "unslop"
        ]
        ++ skillsFrom "${inputs.tstack}/skills" [
          "leaving-pr-comments"
          "modernize"
        ];
    in
    {
      # One symlink per skill, so the rest of these directories (Claude
      # Code's synced/ and .trash/, skills installed by other tools) stays
      # writable and untouched. Two skills with the same name fail the build
      # as conflicting definitions.
      home.file = lib.mkMerge (
        map (skill: {
          ".claude/skills/${skill.name}".source = skill.source;
          ".agents/skills/${skill.name}".source = skill.source;
        }) skills
      );
    };
}
