# Searches for packages containing a specific file in the Nix store.
#
# This function wraps the `nix-locate` command with some additional logic to make it easier to use.
# Returns a raw unprocessed string of results in the format given by `nix-locate`.
def search_packages_raw [
    file_to_search: string, # The file or search term to search for occurences of in the Nix store
    force_not_library?: bool, # If true, the search term will not be prefixed with /lib/
    floating_file_location?: bool, # If true, the search will not be restricted to the file root of packages
    deep_search?: bool # If true, the search will not be restricted to top-level packages
]: nothing -> string {
    # Populating the default values for the parameters if they are not provided
    let floating_file_location: bool = $floating_file_location | default false;
    let deep_search: bool = $deep_search | default false;
    let force_not_library: bool = $force_not_library | default false;

    # Construct our arguments for nix-locate
    let at_root_search: string = match $floating_file_location {
        true => "",
        false => "--at-root"
    };
    let top_level_search: string = match $deep_search {
        true => "",
        false => "--top-level"
    };

    # For convenience, /lib/ is automatically prefixed to our search term
    # For whatever reason, if this need to be overridden, that's what force_not_library is for
    let search_term: string = match $force_not_library {
        true => $file_to_search,
        false => $"/lib/($file_to_search)"
    };


    # The tildes below are used to mark the command for post-processing.
    # It will be replaced with an absolute path to the binary.
    ~nix-locate~ $search_term $at_root_search $top_level_search | collect # We collect to prevent a stream from potentially misbehaving
}

# Converts the fed in raw string results from `nix-locate` into a table with columns for Package, Size, Type, and Path.
def tabularize_nix-locate_results [
    regex_capture?: string # Optional regex to capture specific data from the raw string, if not provided, the default regex will be used
]: string -> table<Package: string, Size: string, Type: string, Path: string> {
    let entry_list: list<string> = $in | lines --skip-empty;

    # Rather complicated regex which captures the following:
    # Package name, removing parenthesis if present as well as the .out suffix
    # Size, which is a number with commas
    # Type, which is a single character representing the type like direcotry or file, we will replace this with a full word later
    # And finally the path, which is a nix store path
    let default_regex: string = '^(?:\({0,1})(?:(?<Package>[^\s]{1,})\.out)(?:\){0,1})\s{1,}(?<Size>[0-9,]{1,})\s(?<Type>[a-z])\s(?<Path>/nix/store/[^\s]{1,})$';
    let data_capturing_regex: string = ( $regex_capture | default $default_regex );

    $entry_list | parse --regex $data_capturing_regex
}

# Sorts the inputted table by a specified columns string length.
def sort_table_column_by_string_length [
    column_name: string # The name of the column to sort by
    sort_direction?: string # Sorting direction, alowed values are 'ascending', and 'descending'
    sort_closure?: closure # For overriding the sort closure used
]: table -> table {
    let sort_direction: string = $sort_direction | default 'ascending';
    # Nu still doesn't have enums, so we have to sanatize our inputs the old way
    if ( $sort_direction != 'ascending' and $sort_direction != 'descending' ) {
        return (
            error make {
                msg: "Unsupported sorting direction!",
                label: {
                    text: "Bad value here",
                    span: (metadata $sort_direction).span
                }
            }
        )
    }

    let sort_closure: closure = $sort_closure | default {
        (
            match $sort_direction {
                # We typed out the entire expression twice because casting a string/character to a math operator isn't straight-forward
                'ascending' => {|entry1, entry2| ($entry1.Path | str length) < ($entry2.Path | str length)}
                'descending' => {|entry1, entry2| ($entry1.Path | str length) > ($entry2.Path | str length)}
            }
        )
    };

    $in | sort-by --custom $sort_closure
}

# Adds the word bytes to every string in the Aize column of a table parsed out of a nix-locate result
def add_bytes_word_to_column []: table<Package: string, Size: string, Type: string, Path: string> -> table<Package: string, Size: string, Type: string, Path: string> {
    # Adding the string bytes to the size for easy human readability
    let size_bytes_string_annotation: closure = {
        |entry|
        # Clone the entry so we can mutate it
        mut result: record<Package: string, Size: string, Type: string, Path: string> = $entry;
        $result.Size = (
            $entry.Size | append "bytes" | str join " "
        );
        $result
    };

    $in | each $size_bytes_string_annotation
}

# Replaces the shortened types in the nix-locate table with expanded words.
def expand_nix-locate_types []: table<Package: string, Size: string, Type: string, Path: string> -> table<Package: string, Size: string, Type: string, Path: string> {
    $in | each {
        |entry|
        mut result: record<Package: string, Size: string, Type: string, Path: string> = $entry;
        $result.Type = match $entry.Type {
            'r' => "Regular File"
            'x' => "Executable"
            'd' => "Directory"
            's' => "Symlink"
        };
        $result
    }
}

# An easy wrapper for the nix-locate command.
#
# While it makes using it easier, it also returns the result in a parsed data format
def "nix locate" [
    search: string # The file/term to search nixpkgs for
    not_library?: bool # Used to override the default convenience prefix, for non-libraries
]: nothing -> table<Package: string, Size: string, Type: string, Path: string> {
    # Very simple, just pass the data through each stage.
    search_packages_raw $search $not_library |
    tabularize_nix-locate_results |
    sort_table_column_by_string_length "Path" |
    add_bytes_word_to_column
}