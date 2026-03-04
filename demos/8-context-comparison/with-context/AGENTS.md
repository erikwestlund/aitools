# AGENTS.md

## Rules for ggplot2

- Use `theme_minimal(base_size = 14)` as the base theme.
- Set `legend.position = "bottom"` in theme.
- Use `scale_color_brewer(palette = "Dark2")` for discrete color scales.
- Axis labels must include units when applicable: e.g., "Length (mm)", "Mass (g)".
- Add a subtitle describing the data source.
- Add a caption with "Source: " and the dataset origin.
- Drop rows with missing values before plotting.
- Do not use causal language in interpretation.

## Examples

- Good axis label: "Concentration (mg/L)"
- Good interpretation: "Group A tended to have higher values than Group B."
- Bad interpretation: "Higher X causes higher Y."
