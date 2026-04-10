# install.packages("jsonlite")
# Example:
# Rscript extract_sim_metadata.R datasets/mtcars.csv outputs/mtcars

args <- commandArgs(trailingOnly = TRUE)

input_path <- if (length(args) >= 1) args[1] else "data/mtcars.csv"
output_dir <- if (length(args) >= 2) args[2] else "outputs/"

if (!requireNamespace("jsonlite", quietly = TRUE)) {
  stop("Please install the 'jsonlite' package before running this script.")
}

if (!file.exists(input_path)) {
  stop("Input file does not exist: ", input_path)
}

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

data <- utils::read.csv(input_path, stringsAsFactors = FALSE, check.names = FALSE)

infer_kind <- function(x) {
  if (inherits(x, c("Date", "POSIXct", "POSIXlt"))) {
    return("date")
  }

  if (is.factor(x) || is.character(x) || is.logical(x)) {
    return("categorical")
  }

  if (is.integer(x)) {
    unique_non_missing <- unique(stats::na.omit(x))
    if (length(unique_non_missing) <= 10) {
      return("categorical_numeric")
    }
    return("integer")
  }

  if (is.numeric(x)) {
    unique_non_missing <- unique(stats::na.omit(x))
    if (length(unique_non_missing) <= 10) {
      return("categorical_numeric")
    }
    return("numeric")
  }

  class(x)[1]
}

format_value <- function(x) {
  if (inherits(x, c("Date", "POSIXct", "POSIXlt"))) {
    return(as.character(x))
  }

  if (is.factor(x)) {
    return(as.character(x))
  }

  if (is.logical(x)) {
    return(as.character(x))
  }

  as.character(x)
}

build_variable_row <- function(name, x) {
  non_missing <- x[!is.na(x)]
  is_num_like <- is.numeric(x) || is.integer(x)
  kind <- infer_kind(x)

  data.frame(
    variable = name,
    class = paste(class(x), collapse = ";"),
    kind = kind,
    n = length(x),
    n_missing = sum(is.na(x)),
    pct_missing = mean(is.na(x)),
    n_unique_non_missing = length(unique(non_missing)),
    min_value = if (length(non_missing) > 0 && (is_num_like || inherits(x, c("Date", "POSIXct", "POSIXlt")))) format_value(min(non_missing)) else NA_character_,
    max_value = if (length(non_missing) > 0 && (is_num_like || inherits(x, c("Date", "POSIXct", "POSIXlt")))) format_value(max(non_missing)) else NA_character_,
    mean_value = if (length(non_missing) > 0 && is_num_like) mean(non_missing) else NA_real_,
    sd_value = if (length(non_missing) > 1 && is_num_like) stats::sd(non_missing) else NA_real_,
    median_value = if (length(non_missing) > 0 && is_num_like) stats::median(non_missing) else NA_real_,
    q25_value = if (length(non_missing) > 0 && is_num_like) stats::quantile(non_missing, probs = 0.25, names = FALSE) else NA_real_,
    q75_value = if (length(non_missing) > 0 && is_num_like) stats::quantile(non_missing, probs = 0.75, names = FALSE) else NA_real_,
    stringsAsFactors = FALSE
  )
}

build_level_rows <- function(name, x) {
  kind <- infer_kind(x)
  non_missing <- x[!is.na(x)]

  if (length(non_missing) == 0) {
    return(data.frame())
  }

  if (!(kind %in% c("categorical", "categorical_numeric"))) {
    return(data.frame())
  }

  counts <- sort(table(non_missing), decreasing = TRUE)

  data.frame(
    variable = name,
    value = names(counts),
    count = as.integer(counts),
    proportion = as.numeric(counts) / length(non_missing),
    stringsAsFactors = FALSE
  )
}

build_examples_row <- function(name, x, max_examples = 10) {
  non_missing <- unique(x[!is.na(x)])
  if (length(non_missing) == 0) {
    examples <- character(0)
  } else {
    examples <- utils::head(format_value(non_missing), max_examples)
  }

  data.frame(
    variable = name,
    example_values = paste(examples, collapse = " | "),
    stringsAsFactors = FALSE
  )
}

variable_metadata <- do.call(
  rbind,
  lapply(names(data), function(name) build_variable_row(name, data[[name]]))
)

value_levels_list <- lapply(names(data), function(name) build_level_rows(name, data[[name]]))
value_levels_list <- value_levels_list[lengths(value_levels_list) > 0]

if (length(value_levels_list) > 0) {
  value_levels <- do.call(rbind, value_levels_list)
} else {
  value_levels <- data.frame()
}

example_values <- do.call(
  rbind,
  lapply(names(data), function(name) build_examples_row(name, data[[name]]))
)

variable_metadata <- merge(variable_metadata, example_values, by = "variable", all.x = TRUE)
variable_metadata <- variable_metadata[match(names(data), variable_metadata$variable), ]

utils::write.csv(
  variable_metadata,
  file = file.path(output_dir, "variable_metadata.csv"),
  row.names = FALSE
)

if (nrow(value_levels) > 0) {
  utils::write.csv(
    value_levels,
    file = file.path(output_dir, "value_levels.csv"),
    row.names = FALSE
  )
}

jsonlite::write_json(
  list(
    input_path = input_path,
    n_rows = nrow(data),
    n_columns = ncol(data),
    variables = lapply(seq_len(nrow(variable_metadata)), function(i) as.list(variable_metadata[i, , drop = FALSE])),
    value_levels = if (nrow(value_levels) > 0) split(value_levels, value_levels$variable) else list()
  ),
  path = file.path(output_dir, "simulation_metadata.json"),
  pretty = TRUE,
  auto_unbox = TRUE,
  na = "null"
)

message("Saved outputs to ", output_dir)
