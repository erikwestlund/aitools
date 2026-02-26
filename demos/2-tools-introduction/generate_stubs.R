#!/usr/bin/env Rscript

args_all <- commandArgs(trailingOnly = FALSE)
file_arg <- "--file="
script_path <- sub(file_arg, "", args_all[grep(file_arg, args_all)][1])
root <- normalizePath(dirname(script_path), winslash = "/", mustWork = TRUE)

source_dir <- file.path(root, "source")
worked_dir <- file.path(root, "worked")
chat_template_path <- file.path(source_dir, "02-tools-chat-template.qmd")
simple_template_path <- file.path(source_dir, "02-tools-simple-template.qmd")
detailed_template_path <- file.path(source_dir, "02-tools-detailed-template.qmd")

harnesses <- data.frame(
  key = c("claude-code", "codex-cli", "opencode", "browser-agent"),
  label = c("Claude Code", "Codex CLI", "OpenCode", "Browser Agent"),
  stringsAsFactors = FALSE
)

models <- data.frame(
  key = c(
    "opus-4-6",
    "codex-gpt-5-3",
    "kimi-k2-5",
    "gemini-3-1-pro",
    "glm-5",
    "haiku-4-5"
  ),
  label = c(
    "Opus 4.6",
    "Codex GPT-5.3",
    "Kimi K2.5",
    "Gemini 3.1 Pro",
    "GLM-5",
    "Haiku 4.5"
  ),
  stringsAsFactors = FALSE
)

if (!dir.exists(worked_dir)) dir.create(worked_dir, recursive = TRUE)

chat_template <- paste(readLines(chat_template_path, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
simple_template <- paste(readLines(simple_template_path, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
detailed_template <- paste(readLines(detailed_template_path, warn = FALSE, encoding = "UTF-8"), collapse = "\n")

render_stub <- function(template_text, harness, harness_label, model, model_label) {
  out <- gsub("\\{\\{HARNESS\\}\\}", harness, template_text)
  out <- gsub("\\{\\{HARNESS_LABEL\\}\\}", harness_label, out)
  out <- gsub("\\{\\{MODEL\\}\\}", model, out)
  out <- gsub("\\{\\{MODEL_LABEL\\}\\}", model_label, out)
  out
}

generated <- 0L

# clear old generated notebooks in worked/
existing_qmd <- list.files(worked_dir, pattern = "\\.qmd$", full.names = TRUE)
if (length(existing_qmd) > 0) invisible(file.remove(existing_qmd))

# chat stub: only browser agent, only chatgpt + claude
browser_models <- data.frame(
  key = c("chatgpt", "claude"),
  label = c("ChatGPT", "Claude"),
  stringsAsFactors = FALSE
)

for (j in seq_len(nrow(browser_models))) {
  model <- browser_models$key[j]
  model_label <- browser_models$label[j]

  filename <- sprintf("02-tools-chat-browser-agent-%s.qmd", model)
  out <- render_stub(chat_template, "browser-agent", "Browser Agent", model, model_label)

  writeLines(out, file.path(worked_dir, filename), useBytes = TRUE)
  generated <- generated + 1L
}

for (i in seq_len(nrow(harnesses))) {
  harness <- harnesses$key[i]
  harness_label <- harnesses$label[i]

  if (harness == "browser-agent") {
    next
  } else if (harness == "claude-code") {
    current_models <- data.frame(
      key = c("opus-4-6", "sonnet-4-6"),
      label = c("Opus 4.6", "Sonnet 4.6"),
      stringsAsFactors = FALSE
    )
  } else if (harness == "codex-cli") {
    current_models <- data.frame(
      key = c("codex-gpt-5-3", "codex-gpt-5-2"),
      label = c("Codex GPT-5.3", "Codex GPT-5.2"),
      stringsAsFactors = FALSE
    )
  } else {
    current_models <- models
  }

  for (j in seq_len(nrow(current_models))) {
    model <- current_models$key[j]
    model_label <- current_models$label[j]

    simple_filename <- sprintf("02-tools-simple-%s-%s.qmd", harness, model)
    simple_out <- render_stub(simple_template, harness, harness_label, model, model_label)

    writeLines(simple_out, file.path(worked_dir, simple_filename), useBytes = TRUE)
    generated <- generated + 1L

    detailed_filename <- sprintf("02-tools-detailed-%s-%s.qmd", harness, model)
    detailed_out <- render_stub(detailed_template, harness, harness_label, model, model_label)

    writeLines(detailed_out, file.path(worked_dir, detailed_filename), useBytes = TRUE)
    generated <- generated + 1L
  }
}

cat(sprintf("Generated %d stubs in worked/.\n", generated))
