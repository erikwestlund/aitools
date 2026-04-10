* Edit these paths for the dataset you want to summarize.
local input_file "datafile.csv"
local output_dir "outputs/"

capture mkdir "`output_dir'"

import delimited using "`input_file'", clear varnames(1)

local n_rows = _N
local variables: varlist _all
local n_columns : word count `variables'

tempfile metadata
tempname postmeta

postfile `postmeta' ///
    str64 variable ///
    str80 storage_type ///
    str40 kind ///
    double n ///
    double n_missing ///
    double pct_missing ///
    double n_unique_non_missing ///
    str120 min_value ///
    str120 max_value ///
    double mean_value ///
    double sd_value ///
    double median_value ///
    double q25_value ///
    double q75_value ///
    str244 example_values ///
    using `metadata', replace

capture mkdir "`output_dir'/value_levels"

foreach var of local variables {
    quietly count if missing(`var')
    local n_missing = r(N)
    local pct_missing = r(N) / `n_rows'

    capture noisily levelsof `var' if !missing(`var'), local(levels_local) clean
    if _rc {
        local levels_local ""
    }

    local n_unique_non_missing : word count `levels_local'
    local storage_type : type `var'
    local kind "categorical"
    if strpos("`storage_type'", "str") == 1 {
        local kind "categorical"
    }
    else {
        if `n_unique_non_missing' <= 10 {
            local kind "categorical_numeric"
        }
        else {
            local kind "numeric"
        }
    }

    local min_value ""
    local max_value ""
    local mean_value = .
    local sd_value = .
    local median_value = .
    local q25_value = .
    local q75_value = .

    if strpos("`storage_type'", "str") != 1 {
        quietly summarize `var' if !missing(`var'), detail
        local min_value = string(r(min))
        local max_value = string(r(max))
        local mean_value = r(mean)
        local sd_value = r(sd)
        local median_value = r(p50)
        local q25_value = r(p25)
        local q75_value = r(p75)
    }

    local example_values ""
    local i = 0
    foreach value of local levels_local {
        local ++i
        if `i' <= 10 {
            if `i' == 1 {
                local example_values "`value'"
            }
            else {
                local example_values "`example_values' | `value'"
            }
        }
    }

    post `postmeta' ///
        ("`var'") ///
        ("`storage_type'") ///
        ("`kind'") ///
        (`n_rows') ///
        (`n_missing') ///
        (`pct_missing') ///
        (`n_unique_non_missing') ///
        ("`min_value'") ///
        ("`max_value'") ///
        (`mean_value') ///
        (`sd_value') ///
        (`median_value') ///
        (`q25_value') ///
        (`q75_value') ///
        ("`example_values'")

    if inlist("`kind'", "categorical", "categorical_numeric") {
        preserve
            keep `var'
            keep if !missing(`var')
            contract `var'
            rename _freq count
            gen variable = "`var'"
            egen total_count = total(count)
            gen proportion = count / total_count
            tostring `var', gen(value) format(%40.0g) force
            keep variable value count proportion
            export delimited using "`output_dir'/value_levels/`var'_levels.csv", replace
        restore
    }
}

postclose `postmeta'

use `metadata', clear
export delimited using "`output_dir'/variable_metadata.csv", replace

clear
set obs 1
gen input_file = "`input_file'"
gen n_rows = `n_rows'
gen n_columns = `n_columns'
export delimited using "`output_dir'/dataset_summary.csv", replace

display "Saved outputs to `output_dir'"
