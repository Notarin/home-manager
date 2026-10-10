#!/usr/bin/env nu

# Parses an SSH configuration file to extract all configured host aliases.
def get-ssh-hosts [
    ssh_config_path: string # The path to the SSH config file
]: nothing -> list<string> {
    open $ssh_config_path
    | ^jc --ssh-conf
    | from json
    | get host_list?
    | compact
    | flatten
}

# Prompts with dmenu
#
# On user cancellation, returns an empty string.
def prompt-host []: list<string> -> string {
    let input: string = ($in | str join "\n")
    let result: record<stdout: string, stderr: string, exit_code: int> = (
        do --ignore-errors { $input | ^fuzzel --dmenu --prompt "ssh: " } | complete
    )
    
    if $result.exit_code == 0 {
        $result.stdout | str trim
    } else {
        ""
    }
}

# Selects an SSH host interactively and launches a WezTerm SSH session.
#
# Reads the SSH config, presents a dmenu, and launches wezterm ssh.
export def main [
    --config: string = "~/.ssh/config" # Path to the SSH config file
]: nothing -> nothing {
    let expanded_config: string = ($config | path expand)

    if not ($expanded_config | path exists) {
        error make { msg: $"SSH config file not found at ($expanded_config)" }
    }

    let hosts: list<string> = (get-ssh-hosts $expanded_config)

    if ($hosts | is-empty) {
        error make { msg: "No SSH hosts found in configuration." }
    }

    let selected_host: string = ($hosts | prompt-host)

    if $selected_host != "" {
        exec wezterm ssh $selected_host
    }
}