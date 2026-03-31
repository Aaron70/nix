{ ... }: 

{
  flake.wrapperHelpers.oh-my-posh = {
    prompts.default = {  colors, ... }: ''
      {
        "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
        "final_space": true,
        "console_title_template": "{{ .Shell }} in {{ .Folder }}",
        "version": 4,
        "blocks": [
          {
            "type": "prompt",
            "alignment": "left",
            "overflow": "hide",
            "segments": [
              {
                "type": "path",
                "style": "plain",
                "background": "transparent",
                "foreground": "${colors.base0D}",
                "template": " {{ .Path }} ",
                "options": {
                  "style": "folder"
                }
              },
              {
                "type": "git",
                "style": "plain",
                "foreground": "${colors.base07}",
                "background": "transparent",
                "github_icon": " ",
                "gitlab_icon": " ",
                "bitbucket_icon": " ",
                "template": "{{ .UpstreamIcon }} {{ if or (.Working.Changed) (.Staging.Changed) }} {{ end }}{{ .HEAD }}<cyan>{{ if gt .Behind 0 }}⇣{{ end }}{{ if gt .Ahead 0 }}⇡{{ end }}</>",
                "properties": {
                  "branch_icon": "",
                  "fetch_status": true,
                  "fetch_upstream_icon": true,
                  "mapped_branches": {
                    "feature/*": "feat/"
                  }
                }
              }
            ]
          },
          {
            "type": "prompt",
            "alignment": "right",
            "overflow": "hide",
            "segments": [
              {
                "type": "executiontime",
                "style": "plain",
                "foreground_templates": [
                  "{{if gt .Code 0}}${colors.base08}{{else}}${colors.base0B}{{end}}"
                ],
                "template": " {{ .FormattedMs }}",
                "options": {
                  "threshold": 1000,
                  "style": "austin"
                }
              }
            ]
          },
          {
            "type": "prompt",
            "alignment": "left",
            "newline": true,
            "segments": [
              {
                "type": "os",
                "style": "plain",
                "foreground_templates": [
                  "{{if gt .Code 0}}${colors.base08}{{end}}",
                  "{{if le .Code 0}}${colors.base0C}{{end}}"
                ],
                "background": "transparent",
                "template": "{{ if .WSL }}WSL at {{ end }}{{.Icon}} "
              },
              {
                "type": "text",
                "style": "plain",
                "foreground_templates": [
                  "{{if gt .Code 0}}${colors.base08}{{end}}",
                  "{{if eq .Code 0}}${colors.base0D}{{end}}"
                ],
                "background": "transparent",
                "template": ""
              }
            ]
          }
        ],
        "transient_prompt": {
          "foreground": "${colors.base0D}",
          "background": "transparent",
          "template": " "
        },
        "secondary_prompt": {
          "foreground": "${colors.base0D}",
          "background": "transparent",
          "template": " "
        }
      }
    '';

    prompts.robots = { colors, ... }: ''
      {
        "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
        "final_space": true,
        "console_title_template": "{{ .Shell }} in {{ .Folder }}",
        "version": 4,
        "blocks": [
          {
            "type": "prompt",
            "alignment": "left",
            "overflow": "hide",
            "segments": [
              {
                "type": "os",
                "style": "plain",
                "foreground_templates": [
                  "{{if gt .Code 0}}${colors.base08}{{end}}",
                  "{{if le .Code 0}}${colors.base0C}{{end}}"
                ],
                "background": "transparent",
                "template": "{{ if .WSL }}WSL at {{ end }}{{.Icon}} "
              },
              {
                "type": "path",
                "style": "plain",
                "background": "transparent",
                "foreground": "${colors.base0D}",
                "template": "  {{ .Path }} ",
                "options": {
                  "style": "folder"
                }
              },
              {
                "type": "git",
                "style": "plain",
                "foreground": "${colors.base07}",
                "background": "transparent",
                "github_icon": " ",
                "gitlab_icon": " ",
                "bitbucket_icon": " ",
                "template": "{{ .UpstreamIcon }}  at ",
                "properties": {
                  "fetch_upstream_icon": true
                }
              },
              {
                "type": "git",
                "style": "powerline",
                "powerline_symbol": "",
                "leading_powerline_symbol": "",
                "foreground": "transparent",
                "background": "${colors.base07}",
                "template": "{{ .HEAD }}<cyan>{{ if gt .Behind 0 }}⇣{{ end }}{{ if gt .Ahead 0 }}⇡{{ end }}</>",
                "properties": {
                  "branch_icon": "",
                  "fetch_status": true,
                  "mapped_branches": {
                    "main": " main",
                    "main/*": " ",
                    "develop": " develop",
                    "develop/*": " ",
                    "feature/*": " ",
                    "feat/*": " ",
                    "bug/*": " ",
                    "poc/*": "󰙨 "
                  }
                }
              }
            ]
          },
          {
            "type": "prompt",
            "alignment": "right",
            "overflow": "hide",
            "segments": [
              {
                "type": "executiontime",
                "style": "plain",
                "foreground_templates": [
                  "{{if gt .Code 0}}${colors.base08}{{else}}${colors.base0B}{{end}}"
                ],
                "template": " {{ .FormattedMs }}",
                "options": {
                  "threshold": 1000,
                  "style": "austin"
                }
              }
            ]
          },
          {
            "type": "prompt",
            "alignment": "left",
            "newline": true,
            "segments": [
              {
                "type": "text",
                "style": "plain",
                "foreground_templates": [
                  "{{if gt .Code 0}}${colors.base08}{{end}}",
                  "{{if eq .Code 0}}transparent{{end}}"
                ],
                "foreground": "${colors.base0C}",
                "template": "{{ if gt .Code 0}}󱚝 {{else}}󰚩 {{end}}"
              }
            ]
          }
        ],
        "transient_prompt": {
          "foreground": "${colors.base0D}",
          "background": "transparent",
          "template": "󱚡  "
        },
        "secondary_prompt": {
          "foreground": "${colors.base0D}",
          "background": "transparent",
          "template": "󱙺 "
        }
      }
    '';

    prompts.custom = { promptIcon, transientPromptIcon, secundaryPromptIcon, colors, ... }: ''
      {
        "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
        "final_space": true,
        "console_title_template": "{{ .Shell }} in {{ .Folder }}",
        "version": 4,
        "blocks": [
          {
            "type": "prompt",
            "alignment": "left",
            "overflow": "hide",
            "segments": [
              
              {
                "type": "path",
                "style": "plain",
                "background": "transparent",
                "foreground": "${colors.base0D}",
                "template": "  {{ .Path }} ",
                "options": {
                  "style": "folder"
                }
              },
              {
                "type": "git",
                "style": "plain",
                "foreground": "${colors.base07}",
                "background": "transparent",
                "github_icon": " ",
                "gitlab_icon": " ",
                "bitbucket_icon": " ",
                "template": "{{ .UpstreamIcon }}  at ",
                "properties": {
                  "fetch_upstream_icon": true
                }
              },
              {
                "type": "git",
                "style": "powerline",
                "powerline_symbol": "",
                "leading_powerline_symbol": "",
                "foreground": "transparent",
                "background": "${colors.base07}",
                "template": "{{ .HEAD }}<cyan>{{ if gt .Behind 0 }}⇣{{ end }}{{ if gt .Ahead 0 }}⇡{{ end }}</>",
                "properties": {
                  "branch_icon": "",
                  "fetch_status": true,
                  "mapped_branches": {
                    "main": " main",
                    "main/*": " ",
                    "develop": " develop",
                    "develop/*": " ",
                    "feature/*": " ",
                    "feat/*": " ",
                    "bug/*": " ",
                    "poc/*": "󰙨 "
                  }
                }
              }
            ]
          },
          {
            "type": "prompt",
            "alignment": "right",
            "overflow": "hide",
            "segments": [
              {
                "type": "executiontime",
                "style": "plain",
                "foreground_templates": [
                  "{{if gt .Code 0}}${colors.base08}{{else}}${colors.base0B}{{end}}"
                ],
                "template": " {{ .FormattedMs }}",
                "options": {
                  "threshold": 1000,
                  "style": "austin"
                }
              }
            ]
          },
          {
            "type": "prompt",
            "alignment": "left",
            "newline": true,
            "segments": [
              {
                "type": "os",
                "style": "plain",
                "foreground_templates": [
                  "{{if gt .Code 0}}${colors.base08}{{end}}",
                  "{{if le .Code 0}}${colors.base0C}{{end}}"
                ],
                "background": "transparent",
                "template": " {{.Icon}} "
              }
            ]
          }
        ],
        "transient_prompt": {
          "foreground": "${colors.base0D}",
          "background": "transparent",
          "template": " 󱞩 "
        },
        "secondary_prompt": {
          "foreground": "${colors.base0D}",
          "background": "transparent",
          "template": " 󱞩 "
        }
      }
    '';
  };
}
